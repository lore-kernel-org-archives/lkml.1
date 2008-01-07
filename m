Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbYAGQbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbYAGQbo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:31:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753991AbYAGQbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:31:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36754 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbYAGQbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:31:36 -0500
Date: Mon, 7 Jan 2008 17:31:39 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alejandro Riveira =?iso-8859-1?Q?Fern=E1ndez?= 
	<ariveira@gmail.com>,
       Vivek Goyal <vgoyal@in.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: section mismatch warning in head_64.S
Message-ID: <20080107163139.GB16072@uranus.ravnborg.org>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <20080107165344.28e9f1ed@Varda>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080107165344.28e9f1ed@Varda>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2008 at 04:53:44PM +0100, Alejandro Riveira Fernández wrote:
> 
>    MODPOST vmlinux.o
> WARNING: vmlinux.o(.text.head+0xe4): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')
> WARNING: vmlinux.o(.text.head+0xeb): Section mismatch: reference to .init.data.2:trampoline_level4_pgt (between 'ident_complete' and 'secondary_startup_64')

Caused by following patch:
commit 1ab60e0f72f71ec54831e525a3e1154f1c092408
Author: Vivek Goyal <vgoyal@in.ibm.com>
Date:   Wed May 2 19:27:07 2007 +0200

    [PATCH] x86-64: Relocatable Kernel Support

Vivek - will you look after this?

	Sam
