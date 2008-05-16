Return-Path: <linux-kernel-owner+w=401wt.eu-S1758103AbYEPNlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758103AbYEPNlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 09:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755770AbYEPNlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 09:41:11 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:58652 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755736AbYEPNlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 09:41:10 -0400
Message-ID: <482D8EE9.10404@garzik.org>
Date: Fri, 16 May 2008 09:40:57 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, Rick Jones <rick.jones2@hp.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Peterson <cpeterso@cpeterso.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
 IRQF_SAMPLE_RANDOM
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <482C7B18.6060003@garzik.org> <482C7E53.3050300@hp.com> <482C8184.2030906@garzik.org> <482C8550.5000909@intel.com> <482C8D4D.3040702@garzik.org> <20080516132107.GA11304@csclub.uwaterloo.ca>
In-Reply-To: <20080516132107.GA11304@csclub.uwaterloo.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lennart Sorensen wrote:
> On Thu, May 15, 2008 at 03:21:49PM -0400, Jeff Garzik wrote:
>> "no other form of entropy"?   See examples in this thread.
> 
> So where does one get entropy if not the ethernet adapter on many
> embedded systems?  If you have no mouse, no keyboard, no hardware number
> generator, just ethernet ports and a serial console that usually
> receives no input.  While ethernet might not be preferable if you have
> something else, sometimes you really don't have anything else.

Already answered in this thread...  EGD illustrates how many sources of 
entropy remain, even in the example you just gave.

Further, you do not want to rely on entropy from a source that declines 
just as network traffic increases.

	Jeff



