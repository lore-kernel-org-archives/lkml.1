Return-Path: <linux-kernel-owner+w=401wt.eu-S1767991AbXEEE1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767991AbXEEE1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 00:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767990AbXEEE1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 00:27:55 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:50781 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1767985AbXEEE1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 00:27:54 -0400
Date: Fri, 4 May 2007 21:27:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "David A. Madore" <David.Madore@ens.fr>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: patch: VFS: fix passing of AT_PHDR value in auxv to ELF
 interpreter
Message-Id: <20070504212735.9b5698c2.akpm@linux-foundation.org>
In-Reply-To: <20070505033408.GB30453@goelette.ens.fr>
References: <20070504140921.GA23122@goelette.ens.fr>
	<20070504162208.6f4b38b0.akpm@linux-foundation.org>
	<20070505033408.GB30453@goelette.ens.fr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007 23:34:08 -0400 Quentin Godfroy <godfroy@clipper.ens.fr> wrote:

> By the way, is init 32 bits or 64 bits? It could break the ia32
> emulation thing, but not the 64bit native mode.

akpm2:/home/akpm> file /sbin/init      
/sbin/init: ELF 64-bit LSB executable, AMD x86-64, version 1 (SYSV), for GNU/Linux 2.6.9, dynamically linked (uses shared libs), for GNU/Linux 2.6.9, stripped

akpm2:/home/akpm> cat /etc/issue
Fedora Core release 6 (Zod)
Kernel \r on an \m
