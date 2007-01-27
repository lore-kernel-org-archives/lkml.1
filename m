Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbXA0WDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbXA0WDF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 17:03:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932095AbXA0WDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 17:03:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:35886 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbXA0WDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 17:03:03 -0500
Date: Sat, 27 Jan 2007 14:02:33 -0800
From: Andrew Morton <akpm@osdl.org>
To: "Parag Warudkar" <parag.warudkar@gmail.com>
Cc: dsd@gentoo.org, joerg@hydrops.han.de, ak@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 7891] New: vdso page is no longer mapped for
Message-Id: <20070127140233.203ef7d3.akpm@osdl.org>
In-Reply-To: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com>
References: <82e4877d0701271201n3aa5bdf6v7c5fb8e41ee98c80@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 15:01:51 -0500
"Parag Warudkar" <parag.warudkar@gmail.com> wrote:

> Here is a patch that does what Andrew Morton suggested (plus some more
> as explained below) .
> Patch inline below and also attached in case there is whitespace
> damage. Compile tested on i386 with make defconfig; make. If anyone
> can test on other arches and provide feedback that'd be great.

Thanks - I can test elf on powerpc.  Does anyone remember how to
create a.out executables?

Assuming this works, I'm not surew what to do with it.  Jam it into
2.6.20, I guess.  The lateness*largeness product is somewhat high though.

You appear to have generated this patch against an oldish kernel - there are
CONFIG_COMPAT_VDSO changes in there which might muck things up.  I'll see...
