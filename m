Return-Path: <linux-kernel-owner+w=401wt.eu-S1751818AbYGXAoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbYGXAoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 20:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbYGXAoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 20:44:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750736AbYGXAoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 20:44:05 -0400
Date: Wed, 23 Jul 2008 17:40:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexander Viro <aviro@redhat.com>, Eric Paris <eparis@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86_64 ia32 syscall audit fast-path
In-Reply-To: <alpine.LFD.1.10.0807231718020.21274@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807231740010.6031@nehalem.linux-foundation.org>
References: <20080707065615.77BD9154246@magilla.localdomain> <20080707065742.7C119154246@magilla.localdomain> <alpine.LFD.1.10.0807070927090.11076@woody.linux-foundation.org> <alpine.LFD.1.10.0807070937520.11076@woody.linux-foundation.org>
 <20080708000233.E8EF3154244@magilla.localdomain> <20080718113615.GD6875@elte.hu> <20080721235419.CA3BA1541A5@magilla.localdomain> <alpine.LFD.1.10.0807231718020.21274@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 23 Jul 2008, Linus Torvalds wrote:
> 
> I'll test the performance anyway (with CONFIG_AUDIT enabled, of course).

Does indeed look like a big improvement, but as mentioned, no way I can 
pull it in this form.

		Linus
