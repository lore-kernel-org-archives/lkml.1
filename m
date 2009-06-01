Return-Path: <linux-kernel-owner+w=401wt.eu-S1756628AbZFAJ1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628AbZFAJ1R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZFAJ1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:27:08 -0400
Received: from bu3sch.de ([62.75.166.246]:58916 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbZFAJ1H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:27:07 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: parport_pc: Fix subscription bugs
Date: Mon, 1 Jun 2009 11:27:03 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200906011100.34086.mb@bu3sch.de> <20090601101440.203c000a@lxorguk.ukuu.org.uk>
In-Reply-To: <20090601101440.203c000a@lxorguk.ukuu.org.uk>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200906011127.03296.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 June 2009 11:14:40 Alan Cox wrote:
> On Mon, 1 Jun 2009 11:00:33 +0200
> Michael Buesch <mb@bu3sch.de> wrote:
> 
> > This patch fixes array subscription bugs in the parport_pc driver.
> > 
> > drivers/parport/parport_pc.c: In function ‘parport_irq_probe’:
> > drivers/parport/parport_pc.c:1589: warning: array subscript is above array bounds
> > drivers/parport/parport_pc.c: In function ‘parport_pc_probe_port’:
> > drivers/parport/parport_pc.c:1579: warning: array subscript is above array bounds
> > 
> > The patch also fixes a few other array bugs, which the compiler was
> > unable to find. Coding style violations are also fixed.
> 
> Which makes it very hard to see what you are actually changing and
> whether it is a bug. It certainly looks like one but the changes muddled
> in with a random subset of format fixes (even in the area patched only
> some style is fixed)

Yeah well. If I did not fix the style violations, somebody else would have complained
already that when somebody touches some code he should also fix the style issues. ;)
Happened to be several times, so I chose to fix them here...

-- 
Greetings, Michael.
