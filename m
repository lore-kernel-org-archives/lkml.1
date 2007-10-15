Return-Path: <linux-kernel-owner+w=401wt.eu-S1764185AbXJOV4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764185AbXJOV4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbXJOVzw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:55:52 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:46058 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756519AbXJOVzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:55:51 -0400
Subject: Re: [patch] scsi: fix crash in gdth_timeout()
From: James Bottomley <James.Bottomley@SteelEye.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Boaz Harrosh <bharrosh@panasas.com>
In-Reply-To: <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
References: <20071015165534.GA17833@elte.hu>
	 <alpine.LFD.0.999.0710151006400.6887@woody.linux-foundation.org>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 17:55:48 -0400
Message-Id: <1192485348.14524.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 10:08 -0700, Linus Torvalds wrote:
> 
> On Mon, 15 Oct 2007, Ingo Molnar wrote:
> > 
> > A further problem is probably that the GDTH timer is not stopped by a
> > failed GDTH probe?
> 
> Indeed. Maybe this is a better fix?
> 
> That driver is pretty messy, and this should have been found ealier. 
> James? Boaz?

It was:

http://marc.info/?t=119238793200002

and that patch was my best guess for fixing this as well ... do we have
someone with actual hardware to confirm it yet?  (apparently QEMU uses
gdth as some type of emulated controller).

James


