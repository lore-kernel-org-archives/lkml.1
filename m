Return-Path: <linux-kernel-owner+w=401wt.eu-S1755839AbXKFG6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839AbXKFG6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 01:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754580AbXKFG56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 01:57:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44273 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754542AbXKFG56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 01:57:58 -0500
Date: Mon, 5 Nov 2007 22:55:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, tglx@tglx.de, mingo@elte.hu, hpa@zytor.com
Subject: Re: [patch] prepare kprobes code for x86 unification
Message-Id: <20071105225503.f4166b09.akpm@linux-foundation.org>
In-Reply-To: <20071024150047.4144fda0@laptopd505.fenrus.org>
References: <20071024150047.4144fda0@laptopd505.fenrus.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Oct 2007 15:00:47 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> This patch is a first step towards unification of the kprobes
> infrastructure between 32 and 64 bit x86; the patch is mostly
> about removing spurious whitespace changes and about adding
> harmless includes and the like to make the 32/64 files more
> identical.

arch/x86/kernel/kprobes_32.c:94: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:95: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:98: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:99: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:102: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:103: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:106: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:107: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:116: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:117: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:120: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:121: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:124: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:125: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:128: warning: left shift count >= width of type
arch/x86/kernel/kprobes_32.c:129: warning: left shift count >= width of type

just your basic i386 allmodconfig.
