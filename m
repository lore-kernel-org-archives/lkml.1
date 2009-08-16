Return-Path: <linux-kernel-owner+w=401wt.eu-S1753329AbZHPBld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbZHPBld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 21:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZHPBld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 21:41:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57906 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803AbZHPBlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 21:41:32 -0400
Date: Sat, 15 Aug 2009 18:39:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Tejun Heo <tj@kernel.org>, Guillaume Knispel <gknispel@proformatique.com>,
       linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] poll/select: initialize triggered field of struct
 poll_wqueues
In-Reply-To: <20090815181559.d73f0da6.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.01.0908151839310.3162@localhost.localdomain>
References: <20090815193024.121926e6@xilun.lan.proformatique.com> <4A875874.20401@kernel.org> <20090815181559.d73f0da6.akpm@linux-foundation.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 15 Aug 2009, Andrew Morton wrote:
> 
> I tagged this for -stable backporting.  That isn't strictly needed, as
> there's no particular harm caused here.  But using an uninitialised
> variable in the core poll/select code is pretty gross.

Hmm. I committed it when Tejun's ack came in, but I didn't tag it for 
stable. Oh well.

		Linus
