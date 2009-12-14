Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbZLNTGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbZLNTGg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757342AbZLNTGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:06:35 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:46984 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253AbZLNTGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:06:34 -0500
Date: Mon, 14 Dec 2009 11:06:17 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for December 14 (nouveau & AGP)
Message-Id: <20091214110617.1c85d2b3.randy.dunlap@oracle.com>
In-Reply-To: <20091214165927.c08c4784.sfr@canb.auug.org.au>
References: <20091214165927.c08c4784.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B268CB0.01AE:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when CONFIG_AGP=n:

drivers/gpu/drm/nouveau/nouveau_bo.c:315: error: implicit declaration of function 'ttm_agp_backend_init'




BTW:

menuconfig AGP
	tristate "/dev/agpgart (AGP Support)"
	depends on ALPHA || IA64 || PARISC || PPC || X86
	depends on PCI

Can AGP=m?  It's tristate in kconfig, but all of its dependencies
are booleans.

---
~Randy
