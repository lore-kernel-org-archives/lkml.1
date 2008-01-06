Return-Path: <linux-kernel-owner+w=401wt.eu-S1754561AbYAFKQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561AbYAFKQM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 05:16:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752815AbYAFKP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 05:15:56 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752014AbYAFKPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 05:15:55 -0500
Date: Sun, 6 Jan 2008 02:15:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org
Subject: Re: 2.6.24-rc6-mm1: sparc64: undefined reference to `vmemmap_table'
Message-Id: <20080106021554.752dc4b8.akpm@linux-foundation.org>
In-Reply-To: <200801061103.04999.m.kozlowski@tuxland.pl>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	<200801061103.04999.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 6 Jan 2008 11:03:02 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> 	This is from allnoconfig on sparc64:
> 
>   LD      .tmp_vmlinux1
> arch/sparc64/kernel/head.o: In function `kvmap_vmemmap':
> (.text+0x34ec): undefined reference to `vmemmap_table'
> arch/sparc64/kernel/head.o: In function `kvmap_vmemmap':
> (.text+0x34f4): undefined reference to `vmemmap_table'

Happens in mainline too.  Maybe arch/sparc64/kernel/ktlb.S needs to be
taught about CONFIG_SPARSEMEM_VMEMMAP=n.  
