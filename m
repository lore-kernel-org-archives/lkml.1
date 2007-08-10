Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbXHJEv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbXHJEv2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 00:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbXHJEvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 00:51:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:33391 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbXHJEvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 00:51:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JBYTji1fZdIsK5cT1V/Qo55BnVdgrUykUyFelIR0SmkU4AoGVTALoJu/lunXVWgdyjoIbR7aCx7oWXr42MA/HUPZH7c3jNKPmfDn4jh4Knfzo0ZVqaDXrSr79bmq2t3FVwf1rqwzIaUszxNteuHL+6NgcFAwkTJQrL2s7saAjoM=
Message-ID: <a56dfcf00708092151q2c485fb9o328db1ae9802e591@mail.gmail.com>
Date: Fri, 10 Aug 2007 04:51:13 +0000
From: "Dan Merillat" <dan.merillat@gmail.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Eric Sandeen" <sandeen@sandeen.net>,
       "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrea Arcangeli" <andrea@suse.de>, "Matt Mackall" <mpm@selenic.com>,
       "Rene Herman" <rene.herman@gmail.com>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Bodo Eggert" <7eggert@gmx.de>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <18096.23187.887075.943181@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BF104.1040703@gmail.com> <20070719013725.GP11115@waste.org>
	 <20070719112436.GG29728@v2.random>
	 <20070719124419.48c3d610@the-village.bc.nu>
	 <46A9ECD5.3050801@sandeen.net>
	 <20070727183807.2d7dbe7b@the-village.bc.nu>
	 <a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
	 <46B003A3.1090507@sandeen.net>
	 <a56dfcf00708010111n4b862a11wf91fe9677ee46143@mail.gmail.com>
	 <18096.23187.887075.943181@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/1/07, Neil Brown <neilb@suse.de> wrote:

> No, this does not use indefinite stack.
>
> loop will schedule each request to be handled by a kernel thread, so
> requests to 'loop' are serialised, never stacked.
>
> In 2.6.22, generic_make_request detects and serialises recursive calls,
> so unlimited recursion is not possible there either.

Is that saying "before 2.6.22, a read/write on a deeply layered device
would use a lot of stack?"
