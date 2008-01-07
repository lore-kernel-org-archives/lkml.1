Return-Path: <linux-kernel-owner+w=401wt.eu-S1753369AbYAGBSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369AbYAGBSj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbYAGBSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:18:30 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48010
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751651AbYAGBS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:18:29 -0500
Date: Sun, 06 Jan 2008 17:18:28 -0800 (PST)
Message-Id: <20080106.171828.70744419.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: m.kozlowski@tuxland.pl, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: sparc64: undefined reference to `vmemmap_table'
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080106021554.752dc4b8.akpm@linux-foundation.org>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<200801061103.04999.m.kozlowski@tuxland.pl>
	<20080106021554.752dc4b8.akpm@linux-foundation.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Sun, 6 Jan 2008 02:15:54 -0800

> On Sun, 6 Jan 2008 11:03:02 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> 
> > 	This is from allnoconfig on sparc64:
> > 
> >   LD      .tmp_vmlinux1
> > arch/sparc64/kernel/head.o: In function `kvmap_vmemmap':
> > (.text+0x34ec): undefined reference to `vmemmap_table'
> > arch/sparc64/kernel/head.o: In function `kvmap_vmemmap':
> > (.text+0x34f4): undefined reference to `vmemmap_table'
> 
> Happens in mainline too.  Maybe arch/sparc64/kernel/ktlb.S needs to be
> taught about CONFIG_SPARSEMEM_VMEMMAP=n.  

It's pointless to support this thing being off.  If possible
I'd like a method to force it always to be enabled and I'll
look into doing that.
