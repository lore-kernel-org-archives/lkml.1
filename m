Return-Path: <linux-kernel-owner+w=401wt.eu-S1757249AbYBGPxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249AbYBGPxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 10:53:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753860AbYBGPxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 10:53:39 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:14589 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYBGPxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 10:53:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=beMDBKK22T20ONcDpW7OUk8QUamd49On4oLHRi1QOc6yDqB7L7iF0iirj0gsNpoK8v1RQmdrorjasEYVb7D3zX8vPo+6s3nmwpxK9/JlAoV6QJ+w2OVrYOTFDCXDzR/vNhQYQlVvS3ZoptRkVrai6d720ahN4UVKOUJS0odWxJg=
Date: Thu, 7 Feb 2008 10:53:19 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: =?ISO-8859-15?Q?Alejandro_Riveira_Fern=E1ndez?= 
	<ariveira@gmail.com>
cc: parag.warudkar@gmail.com, Frank Mayhar <fmayhar@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
In-Reply-To: <20080207162203.3e3cf5ab@Varda>
Message-ID: <alpine.LRH.1.00.0802071040010.29320@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/> <20080206165045.89b809cc.akpm@linux-foundation.org> <1202345893.8525.33.camel@peace.smo.corp.google.com> <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net> <20080207162203.3e3cf5ab@Varda>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463781375-474341409-1202399607=:29320"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463781375-474341409-1202399607=:29320
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT



On Thu, 7 Feb 2008, Alejandro Riveira Fernández wrote:

> gcc --version
> 
> gcc-4.2 (GCC) 4.2.1 (Ubuntu 4.2.1-5ubuntu4)
>  
> If some fields are empty or look unusual you may have an old version.
> Compare to the current minimal requirements in Documentation/Changes.
>  
> Linux Varda 2.6.24 #2 SMP PREEMPT Fri Jan 25 01:05:47 CET 2008 x86_64 GNU/Linux
>
So x86+SMP+GnuC-4.1.2+Glibc-2.5 = Not reproducible.

   x86_64+SMP+PREEMPT+GnuC-4.1.2+Glibc-2.5 = Reproducible.	

Not sure what the original reporter's $ARCH was.

So next thing worthwhile to try might be to disable PREEMPT and see if 
that cures it.

Parag 
---1463781375-474341409-1202399607=:29320--
