Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYGGQkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYGGQkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:40:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756524AbYGGQjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:39:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58492 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756511AbYGGQjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:39:51 -0400
Date: Mon, 7 Jul 2008 09:39:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: <alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
References: <20080707065615.77BD9154246@magilla.localdomain> <20080707065742.7C119154246@magilla.localdomain> <alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Jul 2008, Linus Torvalds wrote:
> 
> Please don't add more instructions to the fastpath. Especially not 
> relatively slow ones like 'bt'. 

Hmm. If I'm reading it right, you seem to have done this correctly in 4/4 
for the native x86-32 patch. So it looks like you were just a bit lazy in 
3/4?

Or am I missing something?

		Linus
