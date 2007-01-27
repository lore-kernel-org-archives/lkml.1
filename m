Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbXA0IoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbXA0IoS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbXA0IoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:44:17 -0500
Received: from smtp.osdl.org ([65.172.181.24]:45440 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbXA0IoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:44:16 -0500
Date: Sat, 27 Jan 2007 00:44:11 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Alon Bar-Lev" <alon.barlev@gmail.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, "Bernhard Walle" <bwalle@suse.de>
Subject: Re: [PATCH 10/26] Dynamic kernel command-line - ia64
Message-Id: <20070127004411.b0d5872e.akpm@osdl.org>
In-Reply-To: <9e0cf0bf0701270034w491ff69dnb6019b4dd30f6d54@mail.gmail.com>
References: <200701230010.34323.alon.barlev@gmail.com>
	<200701230014.06793.alon.barlev@gmail.com>
	<20070127002453.57b1e071.akpm@osdl.org>
	<9e0cf0bf0701270034w491ff69dnb6019b4dd30f6d54@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 10:34:27 +0200
"Alon Bar-Lev" <alon.barlev@gmail.com> wrote:

> > Please.  Go through the entire patchset, yank all those wrong private
> > declarations of boot_command_line[] and put a *single, kernel-wide*
> > declaration into a single, shared header file.
> 
> I thought of this, while I was making the patch, I could not understand why
> the maintainer did not simply #include <linux/init.h>

"ooh, I'll get in trouble if I edit a non-arch file, and it's a hassle to
add another file to my changeset and I can't be assed testing other
architectures and nobody's looking so I'll just sneak it in there".

> I can add this to any module which declares this by-itself but because
> I cannot test all arch, I am afraid it will cause more problems.
> 
> Preparing a patch... :)

Against next -mm, please.
