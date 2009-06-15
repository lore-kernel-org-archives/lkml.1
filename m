Return-Path: <linux-kernel-owner+w=401wt.eu-S1765717AbZFOSn4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765717AbZFOSn4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:43:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765107AbZFOSnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:43:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34012 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760648AbZFOSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:43:44 -0400
Date: Mon, 15 Jun 2009 11:42:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: hugh.dickins@tiscali.co.uk, linux-kernel@vger.kernel.org, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com, efault@gmx.de,
       npiggin@suse.de, tglx@linutronix.de, mingo@elte.hu,
       linux-tip-commits@vger.kernel.org, torvalds@linux-foundation.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
Message-Id: <20090615114230.9c9b1e64.akpm@linux-foundation.org>
In-Reply-To: <1245089065.13761.19316.camel@twins>
References: <tip-3ff0141aa3a03ca3388b40b36167d0a37919f3fd@git.kernel.org>
	<1245077165.6800.497.camel@laptop>
	<Pine.LNX.4.64.0906151623570.5225@sister.anvils>
	<1245080486.6800.561.camel@laptop>
	<1245089065.13761.19316.camel@twins>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 20:04:25 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> OK, utterly untested, but how does this look?

 arch/x86/include/asm/kmap_types.h |   11 +-
 arch/x86/include/asm/pgtable_32.h |   15 +++
 arch/x86/mm/highmem_32.c          |  148 ++++++++++++++++++++++++++++++++++++--
 include/linux/highmem.h           |   12 ---
 mm/highmem.c                      |   45 -----------
 5 files changed, 164 insertions(+), 67 deletions(-)

Did
http://userweb.kernel.org/~akpm/mmotm/broken-out/kmap_types-make-most-arches-use-generic-header-file.patch
just die a horrid death?

