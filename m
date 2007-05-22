Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbXEVXTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbXEVXTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756332AbXEVXTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:19:06 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56707 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756111AbXEVXTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:19:04 -0400
Date: Tue, 22 May 2007 16:16:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kratochvil <honza@jikos.cz>
Cc: Jiri Kosina <jkosina@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
Message-Id: <20070522161642.b71ddacb.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
	<20070511125629.3df919cf.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
	<20070511133651.63f8a14d.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
	<Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
	<alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2007 22:24:11 +0200 (CEST)
Jan Kratochvil <honza@jikos.cz> wrote:

> This patch is using mmap()'s randomization functionality in such a way 
> that it maps the main executable of (specially compiled/linked -pie/-fpie) 
> ET_DYN binaries onto a random address (in cases in which mmap() is allowed 
> to perform a randomization).

ia64:

arch/ia64/ia32/binfmt_elf32.c:265: error: conflicting types for 'elf32_map'
arch/ia64/ia32/../../../fs/binfmt_elf.c:48: error: previous declaration of 'elf32_map' was here
arch/ia64/ia32/binfmt_elf32.c:265: error: conflicting types for 'elf32_map'
arch/ia64/ia32/../../../fs/binfmt_elf.c:48: error: previous declaration of 'elf32_map' was here
arch/ia64/ia32/../../../fs/binfmt_elf.c:48: warning: 'elf32_map' declared `static' but never defined
arch/ia64/ia32/binfmt_elf32.c:265: warning: 'elf32_map' defined but not used
