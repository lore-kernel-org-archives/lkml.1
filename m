Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbZAINjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbZAINjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbZAINjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:39:09 -0500
Received: from tundra.namei.org ([65.99.196.166]:4945 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087AbZAINjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:39:08 -0500
Date: Sat, 10 Jan 2009 00:38:38 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
cc: LKML <linux-kernel@vger.kernel.org>, Jonathan Cameron <jic23@cam.ac.uk>,
       David Howells <dhowells@redhat.com>, linux-mtd@lists.infradead.org
Subject: Re: [regression] jffs2 gc thread oops in set_dumpable()
In-Reply-To: <20090109142148.35f3a99a@hskinnemoen-d830>
Message-ID: <alpine.LRH.1.10.0901100038100.24230@tundra.namei.org>
References: <20090109142148.35f3a99a@hskinnemoen-d830>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009, Haavard Skinnemoen wrote:

> Hi all,
> 
> The following crash has been observed on an ARM platform (intelmote 2)
> and an AVR32 platform (ATSTK1006). In both cases, it's a NULL pointer
> dereference at virtual address 0x150 from set_dumpable() called from
> one of the jffs2_gcd_mtdX threads, and both boards work fine with
> 2.6.28.

This patch should fix it:

http://marc.info/?l=linux-kernel&m=123141356005033&w=2


-- 
James Morris
<jmorris@namei.org>
