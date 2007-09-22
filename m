Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbXIVP1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbXIVP1W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 11:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753213AbXIVP1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 11:27:15 -0400
Received: from barikada.upol.cz ([158.194.242.200]:35401 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbXIVP1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 11:27:15 -0400
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: sam@ravnborg.org, zippel@linux-m68k.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Unfortunate infinite make recursion
In-Reply-To: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0709221319440.15712@fbirervta.pbzchgretzou.qr>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Sat, 22 Sep 2007 17:42:52 +0200
Message-Id: <E1IZ788-0003LZ-Qs@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Sat, 22 Sep 2007 13:24:32 +0200 (CEST)
[]
> The make O=$PWD truncates the Makefile, making it necessary to run `git 
> checkout Makefile` - should you have git; or reextract the tarball 
> (should you /still/ have it). Well, can we catch this case somehow?

Read-only source-tree for kbuild user, end of question. By current kbuild
one can garbage source by various means. Read-write for quilt, git and
editor users.
____
