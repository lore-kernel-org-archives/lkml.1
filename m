Return-Path: <linux-kernel-owner+w=401wt.eu-S1755869AbZIVNmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869AbZIVNmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbZIVNmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:42:12 -0400
Received: from fifo99.com ([67.223.236.141]:52686 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529AbZIVNmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:42:11 -0400
Subject: Re: [PATCH]lock_stat: Adding "nr_contender" and "max_contender" to
 show  the degree of contention on ticket spinlock
From: Daniel Walker <dwalker@fifo99.com>
To: Yang Xi <yangxilkm@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <d36bb30d0909212310p1195f52eu3d6c53ff1d0c0113@mail.gmail.com>
References: <d36bb30d0909212310p1195f52eu3d6c53ff1d0c0113@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 06:42:16 -0700
Message-Id: <1253626936.6575.39.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 16:10 +1000, Yang Xi wrote:
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index 4e77853..a2396d8 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -172,6 +172,15 @@ static inline int
> __ticket_spin_is_contended(raw_spinlock_t *lock)
>         return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
>  }


You patch is line wrapped .. It means it might not be easy to apply it..
You need to tell your mailer that the patch is "preformatted" . In the
kernel tree look at "Documentation/email-clients.txt" for more
information.

(btw, since your using git anyway you might want to look into using
git-format-patch and git-send-email for submitting)

Daniel


