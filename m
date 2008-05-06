Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbYEFHhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbYEFHhE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 03:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbYEFHgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 03:36:54 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44186 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbYEFHgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 03:36:53 -0400
Date: Tue, 6 May 2008 09:36:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
cc: linux-kernel@vger.kernel.org, ltp-list@lists.sourceforge.net,
       ltp-coverage@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, sam@ravnborg.org
Subject: Re: [RFC PATCH 2/6] kbuild: let addtree result in absolute paths
 only
In-Reply-To: <481F26A0.5010402@de.ibm.com>
Message-ID: <alpine.LNX.1.10.0805060936250.11757@fbirervta.pbzchgretzou.qr>
References: <481F26A0.5010402@de.ibm.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-05-05 17:24, Peter Oberparleiter wrote:
>+++ linux-2.6.26-rc1/scripts/Kbuild.include
>@@ -144,7 +144,7 @@ ld-option = $(call try-run,\
> build := -f $(if $(KBUILD_SRC),$(srctree)/)scripts/Makefile.build obj
> 
> # Prefix -I with $(srctree) if it is not an absolute path.
>-addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1))) $(1)
>+addtree = $(if $(filter-out -I/%,$(1)),$(patsubst -I%,-I$(srctree)/%,$(1)),$(1))

At least make it so that relative can be used whenever possible (e.g. on 
!CONFIG_GCOV)
