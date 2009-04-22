Return-Path: <linux-kernel-owner+w=401wt.eu-S1755181AbZDVD7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755181AbZDVD7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 23:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbZDVD7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 23:59:39 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50191 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665AbZDVD7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 23:59:38 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18926.38431.910952.630575@cargo.ozlabs.ibm.com>
Date: Wed, 22 Apr 2009 13:59:27 +1000
From: Paul Mackerras <paulus@samba.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: subrata@linux.vnet.ibm.com, "Linuxppc-dev" <Linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stefan Bader <stefan.bader@canonical.com>,
       Marcelo Tosatti <marcelo@conectiva.com.br>,
       Adrian Bunk <bunk@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
       "linux-next" <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [BUILD FAILURE 05/12] Next April 21 : PPC64 randconfig [drivers/macintosh/mediabay.o]
In-Reply-To: <200904212104.14665.bzolnier@gmail.com>
References: <1240339875.9110.137.camel@subratamodak.linux.ibm.com>
	<200904212104.14665.bzolnier@gmail.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz writes:

> mediabay shouldn't include <linux/ide.h> unconditionally so
> remove the superfluous include from mediabay.c (<asm/mediabay.h>
> will pull <linux/ide.h> in for CONFIG_BLK_DEV_IDE_PMAC=y).

I don't like relying on second-hand imports like that.  I prefer the
previous patch, that made mediabay depend on CONFIG_BLOCK.

BTW, if including <linux/ide.h> causes an error when CONFIG_BLOCK=n,
then there is a bug in <linux/ide.h>, IMO.

Paul.
