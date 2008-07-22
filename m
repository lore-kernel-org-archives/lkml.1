Return-Path: <linux-kernel-owner+w=401wt.eu-S1755638AbYGVXGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbYGVXGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYGVXG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:06:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44697 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbYGVXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:06:29 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <488667C0.5070708@s5r6.in-berlin.de>
Date: Wed, 23 Jul 2008 01:05:36 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.16) Gecko/20080722 SeaMonkey/1.1.11
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: fw-ohci: TSB43AB22/A dualbuffer workaround
References: <tkrat.6a555e76ba524e73@s5r6.in-berlin.de> <200807221811.26653.jwilson@redhat.com>
In-Reply-To: <200807221811.26653.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Still hoping we can get some confirmation of a chipset bug or a fix from TI 
> for this controller,

Well, indeed, a chipset/board bug isn't entirely ruled out yet.  But 
given that data buffers above 2G don't hurt, only descriptors do, the 
controller is definitely the primary suspect here.
-- 
Stefan Richter
-=====-==--- -=== =-===
http://arcgraph.de/sr/
