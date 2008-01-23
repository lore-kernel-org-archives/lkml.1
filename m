Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYAWLZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYAWLZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 06:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751159AbYAWLZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 06:25:43 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:50484 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbYAWLZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:25:42 -0500
Date: Wed, 23 Jan 2008 12:25:41 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Bryan Wu <cooloney.lkml@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <bryan.wu@analog.com>, Mikael Starvik <starvik@axis.com>,
       David Howells <dhowells@redhat.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>, Matthew Wilcox <matthew@wil.cx>,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] procfs: constify function pointer tables
In-Reply-To: <386072610801230241h750ea592h9658b14fd2aa7058@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0801231224180.12676@fbirervta.pbzchgretzou.qr>
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
  <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr> 
 <386072610801222018l79cca93dlda987af4c2036931@mail.gmail.com> 
 <Pine.LNX.4.64.0801231005090.12676@fbirervta.pbzchgretzou.qr>
 <386072610801230241h750ea592h9658b14fd2aa7058@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 23 2008 18:41, Bryan Wu wrote:
>Oh, this patch does not touch all, following is the missing list:
>---
[...]
>arch/ia64/hp/common/sba_iommu.c:static struct seq_operations ioc_seq_ops = {
>arch/ia64/kernel/perfmon.c:struct seq_operations pfm_seq_ops = {
>arch/ia64/kernel/setup.c:struct seq_operations cpuinfo_op = {
>arch/ia64/sn/kernel/sn2/sn2_smp.c:static struct seq_operations
(and more)
[...]

They were sent as other separate patches to each maintainer.
(without lkml, would have been a needless patchbomb.)
