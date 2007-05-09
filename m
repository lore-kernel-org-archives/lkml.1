Return-Path: <linux-kernel-owner+w=401wt.eu-S1757714AbXEIMIy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757714AbXEIMIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 08:08:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbXEIMIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 08:08:44 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:39318 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbXEIMIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 08:08:43 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17985.47561.298978.466437@gargle.gargle.HOWL>
Date: Wed, 9 May 2007 16:08:41 +0400
To: Nick Piggin <npiggin@suse.de>
Cc: linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] lock bitops
Newsgroups: gmane.linux.kernel
In-Reply-To: <20070508113709.GA19294@wotan.suse.de>
References: <20070508113709.GA19294@wotan.suse.de>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:
 > Hi,

[...]

 >  
 >  /**
 > + * clear_bit_unlock - Clears a bit in memory with release
 > + * @nr: Bit to clear
 > + * @addr: Address to start counting from
 > + *
 > + * clear_bit() is atomic and may not be reordered.  It does

s/clear_bit/clear_bit_unlock/ ?

 > + * contain a memory barrier suitable for unlock type operations.
 > + */
 > +static __inline__ void
 > +clear_bit_unlock (int nr, volatile void *addr)
 > +{

Nikita.
