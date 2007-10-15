Return-Path: <linux-kernel-owner+w=401wt.eu-S934840AbXJOSs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934840AbXJOSs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXJOSoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:44:14 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:8442 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934794AbXJOSoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:44:13 -0400
Message-ID: <4713B4E7.2050001@panasas.com>
Date: Mon, 15 Oct 2007 20:43:51 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
References: <20071015165534.GA17833@elte.hu> <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org> <4713A9FA.4050209@garzik.org>
In-Reply-To: <4713A9FA.4050209@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2007 18:43:53.0527 (UTC) FILETIME=[55C1E470:01C80F5B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15 2007 at 19:57 +0200, Jeff Garzik <jeff@garzik.org> wrote:
> Linus Torvalds wrote:
>> On Mon, 15 Oct 2007, Ingo Molnar wrote:
>>> A further problem is probably that the GDTH timer is not stopped by a
>>> failed GDTH probe?
>> Indeed. Maybe this is a better fix?
>>
>> That driver is pretty messy, and this should have been found ealier. 
>> James? Boaz?
> 
> FWIW, the gdth driver was "super-messy".  With this latest SCSI pull, 
> that severity has been successfully downgraded to "messy" :)
> 
> IMO some easy-to-fix breakage was inevitable with such a large volume of 
> fundamental changes.
> 
> Honestly, the driver is probably rarely run by people that lack the 
> hardware, I bet...
> 
> 	Jeff

It was all "flight by instruments only". I called for HW testers and none 
came forward. All these changes, apart from "successful downgrade to messy"
where also needed in order to push important changes to scsi.

But a little bird said that QEMU might simulate this HW. SO I guess it is
QEMU time for me.

Boaz
