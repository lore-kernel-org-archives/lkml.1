Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZFOIH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZFOIH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbZFOIHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:07:45 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:63585 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZFOIHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:07:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SREnJaXFdUMvQVjjXn77ONkvO12138VjAiFkusaS7/NFDytUosa8tDsp2a9L46j/Th
         w56eZabHW+Py2iXUqN7jkVB3VS7k3ailGs6mZp7u2+YZzzwBVSmtdVZmvO8f/V52+tcM
         m+ywPf1qKqIxzPxyGLvm0ePPmitOyL6Gk7JfI=
MIME-Version: 1.0
In-Reply-To: <20090615071125.GF3544@cr0.nay.redhat.com>
References: <412e6f7f0906131829y6e0abb00j85e221f92ab439d2@mail.gmail.com>
	 <20090615071125.GF3544@cr0.nay.redhat.com>
Date: Mon, 15 Jun 2009 16:07:46 +0800
Message-ID: <412e6f7f0906150107h33b271eam7e610d166967ba70@mail.gmail.com>
Subject: Re: memconsole: a virtual console to record the Oops message for 
	debugging purpose.
From: Changli Gao <xiaosuo@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 3:11 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
> On Sun, Jun 14, 2009 at 09:29:48AM +0800, Changli Gao wrote:
>>
>>the following code is appended to the file mm/bootmem.c
>
>
> Why not a patch?
>
> Your code is a kernel module, why do you append it into
> a non-module source file?
>
bootmem can't be allocated in modules. :(


-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
