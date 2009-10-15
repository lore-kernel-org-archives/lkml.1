Return-Path: <linux-kernel-owner+w=401wt.eu-S1762936AbZJOTIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762936AbZJOTIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762924AbZJOTIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:08:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56511 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758593AbZJOTIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:08:18 -0400
Date: Thu, 15 Oct 2009 21:07:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, esandeen@redhat.com,
       cebbert@redhat.com, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Unnecessary overhead with stack protector.
Message-ID: <20091015190720.GA19467@elte.hu>
References: <20091015183540.GA8098@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015183540.GA8098@redhat.com>
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


(Cc:-ed Arjan too.)

* Dave Jones <davej@redhat.com> wrote:

> 113c5413cf9051cc50b88befdc42e3402bb92115 introduced a change that made 
> CC_STACKPROTECTOR_ALL not-selectable if someone enables 
> CC_STACKPROTECTOR.
> 
> We've noticed in Fedora that this has introduced noticable overhead on 
> some functions, including those which don't even have any on-stack 
> variables.
> 
> According to the gcc manpage, -fstack-protector will protect functions 
> with as little as 8 bytes of stack usage. So we're introducing a huge 
> amount of overhead, to close a small amount of vulnerability (the >0 
> && <8 case).
> 
> The overhead as it stands right now means this whole option is 
> unusable for a distro kernel without reverting the above commit.

Exactly what workload showed overhead, and how much?

	Ingo
