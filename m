Return-Path: <linux-kernel-owner+w=401wt.eu-S965480AbXCQLHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965480AbXCQLHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 07:07:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965521AbXCQLHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 07:07:11 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:35682 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965419AbXCQLHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 07:07:09 -0400
Date: Sat, 17 Mar 2007 05:07:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Paul Mackerras <paulus@samba.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>, suparna@in.ibm.com,
       cmm@us.ibm.com, alex@clusterfs.com, suzuki@in.ibm.com
Subject: Re: [RFC][PATCH] sys_fallocate() system call
Message-ID: <20070317110706.GB29931@parisc-linux.org>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <17915.48105.70494.958220@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17915.48105.70494.958220@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 08:59:05PM +1100, Paul Mackerras wrote:
> ... but wouldn't work on 32-bit powerpc. :(  We would end up with a
> pad argument between fd and offset, giving 7 arguments in all
> (counting the loff_t's as 2), but we only support 6.

Ditto mips and parisc.
