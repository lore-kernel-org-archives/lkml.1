Return-Path: <linux-kernel-owner+w=401wt.eu-S1755916AbZFZHHx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbZFZHHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:07:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754283AbZFZHHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:07:39 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56468 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbZFZHHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xIR2Bm0PQMGvH+S587pYAOSapDcqdqxpMDamsbf1vHPeN7EcaIm2jy+7F46eJzOzBB
         jl05UL+DUC9ceZEXpg5QvyARj6GVka65Lvzs2MtMb3FYnDF9IMnGcxt5j6raZXwf/gQh
         VwmNx77O2mHuTUqyr5JZq4wPNsej95MZ8vbb0=
MIME-Version: 1.0
In-Reply-To: <20090626065923.GA14078@elte.hu>
References: <20090625221816.GA3480@localdomain.by>
	 <20090626065923.GA14078@elte.hu>
Date: Fri, 26 Jun 2009 10:07:39 +0300
X-Google-Sender-Auth: 8d7e85ed0e1c28a2
Message-ID: <84144f020906260007u3e79086bv91900e487ba0fb50@mail.gmail.com>
Subject: Re: kmemleak suggestion (long message)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Catalin Marinas <catalin.marinas@arm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

* Sergey Senozhatsky <sergey.senozhatsky@mail.by> wrote:
>> Currently kmemleak prints info about all objects. I guess
>> sometimes kmemleak gives you more than you actually need.

On Fri, Jun 26, 2009 at 9:59 AM, Ingo Molnar<mingo@elte.hu> wrote:
> It prints _a lot_ of info and spams the syslog. I lost crash info a
> few days ago due to that: by the time i inspected a crashed machine
> the tons of kmemleak output scrolled out the crash from the dmesg
> buffer.
>
> This is not acceptable.
>
> Instead it should perhaps print _at most_ a single line every few
> minutes, printing a summary about _how many_ leaked entries it
> suspects, and should offer a /debug/mm/kmemleak style of file where
> the entries can be read out from.

Yup, makes tons of sense.

                                     Pekka
