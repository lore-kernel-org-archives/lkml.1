Return-Path: <linux-kernel-owner+w=401wt.eu-S1030789AbXAZUjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030789AbXAZUjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030793AbXAZUjP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:39:15 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53939 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030789AbXAZUjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:39:14 -0500
Date: Fri, 26 Jan 2007 12:39:03 -0800
From: Andrew Morton <akpm@osdl.org>
To: Alexey Dobriyan <adobriyan@openvz.org>
Cc: devel@openvz.org, linux-kernel@vger.kernel.org,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 3/3] lutimesat: actual syscall and wire-up on i386
Message-Id: <20070126123903.046aaa5e.akpm@osdl.org>
In-Reply-To: <20070126112345.GC11128@localhost.sw.ru>
References: <20070126112345.GC11128@localhost.sw.ru>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Jan 2007 14:23:45 +0300
Alexey Dobriyan <adobriyan@openvz.org> wrote:

> lutimesat(2) does everything futimesat(2) does except it doesn't follow
> symlinks.
> 
> It could be used by tar(1) and cp(1).
> 
> FreeBSD and NetBSD have lutimes(2) which can be emulated by C library:
> 
> 	lutimesat(AT_FDCWD, filename, utimes)
> 
> Closes http://bugme.osdl.org/show_bug.cgi?id=4433
> 
efine __ARCH_WANT_IPC_PARSE_VERSION
>  #define __ARCH_WANT_OLD_READDIR

OK, but I don't recall having seeing a demand for lutimes().  Opinions
are sought?
