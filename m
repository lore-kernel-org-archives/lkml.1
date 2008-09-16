Return-Path: <linux-kernel-owner+w=401wt.eu-S1753577AbYIPWRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbYIPWRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 18:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbYIPWQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 18:16:56 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:44268 "EHLO
	IE1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbYIPWQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 18:16:55 -0400
X-BigFish: VPS-33(zz1432R98dR1805M936fQzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <48D0310E.1040409@am.sony.com>
Date: Tue, 16 Sep 2008 15:19:58 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Simon Arlott <simon@fire.lp0.eu>, Alan Stern <stern@rowland.harvard.edu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before	late_initcall
 and move level 6s (sync) first
References: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org> <48920481.7010702@simon.arlott.org.uk> <20080731215601.GC4817@kroah.com>
In-Reply-To: <20080731215601.GC4817@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2008 22:16:41.0728 (UTC) FILETIME=[E5688000:01C91849]
X-SEL-encryption-scan: scanned
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jul 31, 2008 at 07:29:21PM +0100, Simon Arlott wrote:
>>>> There is nothing else to run between 1-2 and 3, so there is no 
>>>> opportunity
>>>> to initialise devices in the background and usblp_init blocks for a 
>>>> while.
>>> If it were a module then it would block in a separate thread and wouldn't 
>>> hold up the main init process.
>> Right, but I want to compile all of this into the kernel.
> 
> Why?  It sounds like a trivial solution for you is to actually use
> modules.  Why go through a lot of extra work to solve something in a
> different way that is already solved for you?
> 
> Who is imposing the "no modules allowed" rule on you, and why was it
> made?

Sorry for the massively late response.

Don't know how I missed this thread earlier, but I can answer that
from my standpoint.

At Sony we have a "no modules if possible" policy to reduce kernel
footprint.  The size difference for a kernel compiled with modules
vs one with external modules is about 10% IRRC.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

