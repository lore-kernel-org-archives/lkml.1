Return-Path: <linux-kernel-owner+w=401wt.eu-S1756326AbZFAJNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756326AbZFAJNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753440AbZFAJNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:13:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37618 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753023AbZFAJNe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:13:34 -0400
Date: Mon, 1 Jun 2009 10:14:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: parport_pc: Fix subscription bugs
Message-ID: <20090601101440.203c000a@lxorguk.ukuu.org.uk>
In-Reply-To: <200906011100.34086.mb@bu3sch.de>
References: <200906011100.34086.mb@bu3sch.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Jun 2009 11:00:33 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This patch fixes array subscription bugs in the parport_pc driver.
> 
> drivers/parport/parport_pc.c: In function ‘parport_irq_probe’:
> drivers/parport/parport_pc.c:1589: warning: array subscript is above array bounds
> drivers/parport/parport_pc.c: In function ‘parport_pc_probe_port’:
> drivers/parport/parport_pc.c:1579: warning: array subscript is above array bounds
> 
> The patch also fixes a few other array bugs, which the compiler was
> unable to find. Coding style violations are also fixed.

Which makes it very hard to see what you are actually changing and
whether it is a bug. It certainly looks like one but the changes muddled
in with a random subset of format fixes (even in the area patched only
some style is fixed) looks pretty clunky - surely a for() loop would be
far cleaner.


But yes agreed - its a bug, it wants fixing and style can be sorted later.
