Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbXGOG06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbXGOG06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 02:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751833AbXGOG0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 02:26:51 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:45039 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbXGOG0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 02:26:50 -0400
Date: Sun, 15 Jul 2007 08:27:08 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove PAGE_SIZE from headers_install
Message-ID: <20070715062708.GA11909@aepfle.de>
References: <20070714205709.GA9478@aepfle.de> <8bd0f97a0707141404k16e53945s92b3cd4264ecf0aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8bd0f97a0707141404k16e53945s92b3cd4264ecf0aa@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, Mike Frysinger wrote:

> imo, asm/page.h should just go away for userspace.  the attached patch
> is what i've been using in Gentoo ... but somethings (like an arch or
> two in glibc) still assume asm/page.h is OK.  in general though,
> considering asm/page.h has become so unreliable lately (a large number
> of arches ifdef the whole thing out), most packages out there have
> updated already to use the userspace interface from unistd.h.

You need that signed-off thing, and dont forget to send it to
stable@kernel.org
