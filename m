Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbZLKNGf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbZLKNGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 08:06:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZLKNGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 08:06:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51884 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbZLKNGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 08:06:30 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: What's in asm-generic.git
Date: Fri, 11 Dec 2009 14:06:33 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Mike Frysinger <vapier.adi@gmail.com>, liqin.chen@sunplusct.com,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <OF24184D8B.2F7F8AA9-ON48257685.002069EF-48257685.00207E45@sunplusct.com> <200912102225.05280.arnd@arndb.de> <10f740e80912110454u172fc2cfye30da6ca0e0f0af0@mail.gmail.com>
In-Reply-To: <10f740e80912110454u172fc2cfye30da6ca0e0f0af0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200912111406.33424.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18aWjRKaxvPFDmwwVuI+GeWhBEtBKCmGaohATK
 CSvcAHuXmHTFLskVGpid+YM+2EjoHo+ZbfawKdR9nwiSzrHpJs
 LLqDnk11g780m+O3mCffw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009, Geert Uytterhoeven wrote:
> 10+ architectures already have sys_[sg]et_thread_area of have reserved
> entries for it.

No, those are just the ones that blindly copied the unistd.h file from i386.
As I said, only i386 and mips implement it, and I would assume that this
is unlikely to change.

	Arnd
