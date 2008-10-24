Return-Path: <linux-kernel-owner+w=401wt.eu-S1756840AbYJXO4j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbYJXO4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:56:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYJXO4a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:56:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:50895 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752163AbYJXO4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:56:30 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX1+T8jpJ9tiTjvoFfLlgQCrdPhmuuuWCA9HWIvtVgI
	OZMrW462KODPMe
Date: Fri, 24 Oct 2008 16:56:15 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: git-clean [Was: Linux 2.6.28-rc1]
Message-ID: <20081024145615.GQ16946@atjola.homenet>
References: <alpine.LFD.2.00.0810232028500.3287@nehalem.linux-foundation.org> <200810241224.38541.alistair@devzero.co.uk> <200810241345.04966.rjw@sisk.pl> <200810241352.45745.alistair@devzero.co.uk> <20081024131340.GB24358@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081024131340.GB24358@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008.10.24 17:13:40 +0400, Alexey Dobriyan wrote:
> On Fri, Oct 24, 2008 at 01:52:45PM +0100, Alistair John Strachan wrote:
> > git reset --hard v2.6.27 ; git clean -d -f
> > git status ("Nothing to commit")
> > 
> > cp /path/to/config .config
> > make oldconfig prepare
> > git clean -d -f ; git reset --hard
> > git status ("Nothing to commit")
> > 
> > Observe at this point that include/asm is valid and points to
> > include/asm-x86, despite the clean and reset (I guess this file is
> > being ignored).
> 
> Use this script for super-clean project-agnostic clean:
> 
> 	$ cat ~/bin/git-mrproper
> 	#!/bin/sh
> 	git-ls-files -o --directory -z | xargs -0 rm -rf

JFYI, that should be the same as:
git clean -xdf

The -x makes it wipe out ignored files as well.

Björn
