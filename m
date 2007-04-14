Return-Path: <linux-kernel-owner+w=401wt.eu-S1753674AbXDNQLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbXDNQLd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 12:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753845AbXDNQLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 12:11:33 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10924 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbXDNQLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 12:11:32 -0400
Date: Sat, 14 Apr 2007 09:13:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: bbpetkov@yahoo.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [KERNEL-DOC] kill warnings when building mandocs
Message-Id: <20070414091341.7665d8b0.randy.dunlap@oracle.com>
In-Reply-To: <20070413091422.GA15426@zmei.tnic>
References: <20070413091422.GA15426@zmei.tnic>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007 11:14:22 +0200 Borislav Petkov wrote:

> This patch shuts warnings of the sort:
> 
> make -C /mnt/samsung_200/sam/kernel/trees/21-rc6/build \
> 	KBUILD_SRC=/mnt/samsung_200/sam/kernel/trees/21-rc6 \
> 	KBUILD_EXTMOD="" -f /mnt/samsung_200/sam/kernel/trees/21-rc6/Makefile mandocs
> make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=scripts/basic
> make -f /mnt/samsung_200/sam/kernel/trees/21-rc6/scripts/Makefile.build obj=Documentation/DocBook mandocs
>   SRCTREE=/mnt/samsung_200/sam/kernel/trees/21-rc6/ /mnt/samsung_200/sam/kernel/trees/21-rc6/build/scripts/basic/docproc doc /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/wanbook.tmpl >Documentation/DocBook/wanbook.xml
>   if grep -q refentry Documentation/DocBook/wanbook.xml; then xmlto man -m /mnt/samsung_200/sam/kernel/trees/21-rc6/Documentation/DocBook/stylesheet.xsl -o Documentation/DocBook/man Documentation/DocBook/wanbook.xml ; gzip -f Documentation/DocBook/man/*.9; fi
> Note: meta version: No productnumber or alternative     sppp_close
> Note: meta version: No refmiscinfo@class=version        sppp_close
> Note: Writing sppp_close.9
> Note: meta version: No productnumber or alternative     sppp_open
> Note: meta version: No refmiscinfo@class=version        sppp_open
> 
> by adding a RefMiscInfo xml tag in the form of the current kernel version to 
> the function, struct and enum definitions in files included by kernel-doc when 
> building 'mandocs'.  However, the version string appears truncated on the manpage
> due to some constraints in the xml DTD for the man header, I believe, for the
> troff output is truncated too.

Hi Borislav,

I cannot reproduce this error (either, a la the tex error).
Any hints about how I could do so?

Thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
