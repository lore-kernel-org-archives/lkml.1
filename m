Return-Path: <linux-kernel-owner+w=401wt.eu-S1764433AbYHFJdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764433AbYHFJdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755764AbYHFJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:33:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:14082 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758167AbYHFJdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=R3f+JKnJf/PYJt8bwHNTl3Gy2ayoBqBDGfY/jYK636GddijdNI7DsVMFQnhCYgIPlt
         PjI/Z+3uT3VCQQDzo6aa93Fml58+sVZAYj2QVQWjDkzqAeT6LBHskNOvEaE1p5xVNc48
         sCSIdGgMvd1rSR/2JNie3cka9w243s2QTJgbY=
Message-ID: <b6a2187b0808060233t6bd437edi7e74fa225aaa9d01@mail.gmail.com>
Date: Wed, 6 Aug 2008 17:33:07 +0800
From: "Jeff Chua" <jeff.chua.linux@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.27rc1 cannot boot more than 8CPUs
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080806.001836.135194365.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b6a2187b0808052015g698430fah95b5dc2c25dc396a@mail.gmail.com>
	 <20080805.221917.42858161.davem@davemloft.net>
	 <b6a2187b0808052342w6fba9152m197d56aa9e88746a@mail.gmail.com>
	 <20080806.001836.135194365.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2008 at 3:18 PM, David Miller <davem@davemloft.net> wrote:

> You have to turn off CONFIG_PROVE_LOCKING, in fact just turn off
> everything in the lock debugging section:
>
> # CONFIG_DEBUG_RT_MUTEXES is not set
> # CONFIG_RT_MUTEX_TESTER is not set
> # CONFIG_DEBUG_SPINLOCK is not set
> # CONFIG_DEBUG_MUTEXES is not set
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_SPINLOCK_SLEEP is not set
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
>

I don't any option to turn these off. Still searching.

Jeff.
