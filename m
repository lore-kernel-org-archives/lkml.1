Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbYBDFNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbYBDFNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 00:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750772AbYBDFNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 00:13:14 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:59864 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbYBDFNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 00:13:13 -0500
Date: Mon, 4 Feb 2008 06:13:18 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Coexistence of EXPORT_SYMBOL() and __cpuinit
Message-ID: <20080204051318.GA11255@uranus.ravnborg.org>
References: <804dabb00802031749m7f0765f8q8cd1f6c6a881651c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <804dabb00802031749m7f0765f8q8cd1f6c6a881651c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 04, 2008 at 09:49:24AM +0800, Peter Teoh wrote:
> In kernel/cpu.c, there exists API that is declared as __cpuinit, and
> at the same time exported via EXPORT_SYMBOL().
> 
> Can these two attribute coexists at the same time?   I mean, when it
> is declared with EXPORT_SYMBOL, according to include/linux/module.h,
> it is placed in a __ksymtab section, and when compiled with with
> __cpuinit, according to include/linux/init.h, into a __cpuinit
> section.

kbuild.git contains a commit so we no longer warn about
symbols being exported if annotatated with __cpuinit, __devinit, and
__devinit.

I've requested Linus to pull the changes and expet it to happen
within the next two days.

	Sam
