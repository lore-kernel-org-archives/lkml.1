Return-Path: <linux-kernel-owner+w=401wt.eu-S1755317AbZJPGpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317AbZJPGpp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 02:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbZJPGpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 02:45:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48399 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbZJPGpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 02:45:43 -0400
Date: Fri, 16 Oct 2009 08:44:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@muc.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Howells <dhowells@redhat.com>, Aristeu Rozanski <aris@redhat.com>
Subject: Re: [PATCH V6] x86: NX protection for kernel data
Message-ID: <20091016064433.GC20388@elte.hu>
References: <817ecb6f0910151625o7eb645e8pff574a2c12bdb763@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <817ecb6f0910151625o7eb645e8pff574a2c12bdb763@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Siarhei Liakh <sliakh.lkml@gmail.com> wrote:

> This patch expands functionality of CONFIG_DEBUG_RODATA to set main 
> (static) kernel data area as NX.

thanks - this one looks good now.

Would be nice if you could send this with the patch that also deals with 
the first 1 MB.

	Ingo
