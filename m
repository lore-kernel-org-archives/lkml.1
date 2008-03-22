Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbYCVKXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbYCVKXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 06:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752242AbYCVKXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 06:23:32 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45960 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752941AbYCVKXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 06:23:31 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E4DDFB.4050600@s5r6.in-berlin.de>
Date: Sat, 22 Mar 2008 11:22:51 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Jarod Wilson <jwilson@redhat.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire: wait until PHY configuration packet was transmitted
References: <tkrat.47c2348a94015e02@s5r6.in-berlin.de> <200803212312.41277.jwilson@redhat.com>
In-Reply-To: <200803212312.41277.jwilson@redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarod Wilson wrote:
> Will double-check Monday that this solves never-ending (until panic) bus

s/that/whether/? :-)

> resets with a jmicron controller in the office, but this does indeed prevent 
> a very similar looking case with a via vt6307 ohci 1.0 controller + iogear 
> hub + unibrain fire-i camera:
> 
>   http://bugzilla.kernel.org/show_bug.cgi?id=10128

The wonders of brainstorming on IRC.  Let's implement all far-off and 
weird ideas we can possibly get, distill those which don't cause 
regressions, and we will end up with perfectly working drivers. :-)
-- 
Stefan Richter
-=====-==--- --== =-==-
http://arcgraph.de/sr/
