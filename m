Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbXLRWu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbXLRWu2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 17:50:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752485AbXLRWuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 17:50:19 -0500
Received: from 1wt.eu ([62.212.114.60]:2777 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXLRWuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 17:50:18 -0500
Date: Tue, 18 Dec 2007 23:47:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: Alon Bar-Lev <alon.barlev@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-mips@ftp.linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [MIPS] Build an embedded initramfs into mips kernel
Message-ID: <20071218224702.GI15227@1wt.eu>
References: <9e0cf0bf0712181208m7f16b9acpf3dba67f3556a613@mail.gmail.com> <47683B2D.9030608@zytor.com> <9e0cf0bf0712181409p2475e1fdk779fdee4fa274722@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e0cf0bf0712181409p2475e1fdk779fdee4fa274722@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2007 at 12:09:46AM +0200, Alon Bar-Lev wrote:
> On 12/18/07, H. Peter Anvin <hpa@zytor.com> wrote:
> > Make sure your /init doesn't depend on an interpreter or library which
> > isn't available.
> 
> Thank you for your answer.
> 
> I already checked.
> 
> /init is hardlink to busybox, it depends on libc.so.0 which is available at /lib

Are you sure that libc.so.0 is enough and that you don't need any ld.so ?

> But shouldn't I get a different error code if this is the case?

If it does not find part of the dynamic linker or libraries, this error
makes sense to me.

You should try to build a static init with any stupid thing such as a
hello world to ensure that the problem really comes from the init and
nothing else.

Regards,
Willy

