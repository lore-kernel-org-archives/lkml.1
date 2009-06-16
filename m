Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZFPHf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZFPHf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 03:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZFPHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 03:35:16 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33759 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZFPHfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 03:35:15 -0400
Date: Tue, 16 Jun 2009 08:35:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Brian Swetland <swetland@google.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Robert Love <rlove@google.com>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 1/3] [ARM] msm_serial: serial driver for MSM7K onboard
	serial peripheral.
Message-ID: <20090616073505.GA2208@n2100.arm.linux.org.uk>
References: <1245033557-10968-1-git-send-email-swetland@google.com> <1245033557-10968-2-git-send-email-swetland@google.com> <20090615085216.GC10822@elf.ucw.cz> <a55d774e0906150255h781f7677w9d336257c89200fc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0906150255h781f7677w9d336257c89200fc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 02:55:15AM -0700, Brian Swetland wrote:
> On Mon, Jun 15, 2009 at 1:52 AM, Pavel Machek<pavel@ucw.cz> wrote:
> >
> > Otherwise seems to be okay (plus the issues someone pointed in other
> > email), you can add my acked-by:. I guess you should submit it to
> > rmk's patch system...
> 
> Russell,
> 
> Do you want this stuff to end up in the patch system, or would
> accumulating patches into a for-rmk git branch somewhere make sense?
> That seemed to work reasonably well last time around.  I'm happy to do
> either, but am most comfortable working with git.
> 
> Does that even make sense for stuff like the serial driver or should
> everything outside of arch/arm/... be going through various different
> subsystem maintainers?

If there's no dependency on ARM stuff, it should go via the subsystem
maintainers trees.  In the case of serial, that's Alan.
