Return-Path: <linux-kernel-owner+w=401wt.eu-S933898AbXDAS66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933898AbXDAS66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933899AbXDAS66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:58:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39775 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933898AbXDAS65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:58:57 -0400
Subject: Re: Rebuilding and checksumming the Linux kernel
From: Arjan van de Ven <arjan@infradead.org>
To: Edgardo Hames <ehames@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
References: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 01 Apr 2007 11:58:07 -0700
Message-Id: <1175453887.14923.73.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-01 at 15:56 -0300, Edgardo Hames wrote:
> I'm working on a project with teams spread across the world and we all
> work on the same repository patching the kernel and then integrating
> into a common main branch. Even though we label the source code, we
> would like to make sure that we are all building the same kernel by
> running md5sum on the resulting binary.
> 
> Right now, this is not possible because the kernel includes a
> timestamp and a build number on the binary. What are this timestamps
> used for? Can we just remove them? Is there any other thing that may
> lead to different binaries? (we are using the exact toolchains and
> build machines, so we can assume that the same executable is generated
> if the input source is the same).

elfutils has a "elfcmp" program that may be useful for you

another trick could be to run objdump -d on the vmlinux, and then
compare the assembly file.. you could even grep out any known date like
things that way,,

