Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYGCRCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYGCRCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 13:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYGCRCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 13:02:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59222 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbYGCRCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 13:02:12 -0400
Date: Thu, 3 Jul 2008 18:01:28 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] PalmTX initial support
Message-ID: <20080703170128.GU17201@flint.arm.linux.org.uk>
References: <200807022232.47294.marek.vasut@gmail.com> <20080703074511.GA14481@flint.arm.linux.org.uk> <200807031717.06361.marek.vasut@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807031717.06361.marek.vasut@gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2008 at 05:17:06PM +0200, Marek Vasut wrote:
> Dne Thursday 03 of July 2008 09:45:11 Russell King - ARM Linux napsal(a):
> > On Wed, Jul 02, 2008 at 10:32:47PM +0200, Marek Va??ut wrote:
> > > the following patch adds initial support for PalmTX handheld computer. It
> > > originates from HnD kernel tree (www.hackndev.com), then I pushed it to
> > > handhelds.org and now I'd like it to be applied mainline.
> >
> > There's one other thing that's missing from the patch - an entry for
> > MAINTAINERS.
> 
> Ok, I hope it's all properly fixed now. I applied pxa-pwm patch on my tree and 
> switched to pwm-backlight and used .lcd_conn. Also added to MAINTAINERS.

I'm getting a headache trying to work out where all this stuff should
go.

Right, when you were asked to use the pxa-pwm branch, that was right at
the time.  However, Dmitry Baryshkov recently submitted and I accepted a
patch which sorts out the IrDA support, and your patch misses out on
that change.

So the right place has changed from the pxa-pwm branch to the pxa branch
itself.  Could you regenerate please?

For the IrDA changes, see 5146/1.
