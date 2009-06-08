Return-Path: <linux-kernel-owner+w=401wt.eu-S1757020AbZFHQT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020AbZFHQT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 12:19:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755858AbZFHQTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 12:19:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57913 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbZFHQTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 12:19:51 -0400
Date: Mon, 8 Jun 2009 17:19:29 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       dbaryshkov@gmail.com, omegamoon@gmail.com
Subject: Re: zaurus needs generic pxa suspend/resume routines
Message-ID: <20090608161929.GD32140@n2100.arm.linux.org.uk>
References: <20090605131625.GC1376@ucw.cz> <20090607152152.GA7785@n2100.arm.linux.org.uk> <f17812d70906072358i69b4ce09oeb6cd455277b050f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d70906072358i69b4ce09oeb6cd455277b050f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 02:58:54PM +0800, Eric Miao wrote:
> On Sun, Jun 7, 2009 at 11:21 PM, Russell King - ARM
> Linux<linux@arm.linux.org.uk> wrote:
> > On Fri, Jun 05, 2009 at 03:16:25PM +0200, Pavel Machek wrote:
> >> For suspend/resume to work, spitz needs pxa_pm_suspend/resume to be
> >> called. Otherwise PSPR is not set properly, and system will die during
> >> resume.
> >
> > 100 points for copying lots of people.  0 points for omitting the right
> > person.  Add Eric.
> >
> > Eric, ack?
> >
> 
> Yes, I think this is the best trade-off for the moment.
> 
> Acked-by: Eric Miao <eric.miao@marvell.com>
> 
> And Russell you may want to queue this for this -rc phase, looks
> it's still -rc8-git5.

I think it's missed .30, unless Linus does a -rc9.  I sent what was
probably my final pull request last night.
