Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbYBGC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbYBGC6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 21:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758922AbYBGC6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 21:58:03 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:45239 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYBGC6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 21:58:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:user-agent:mime-version:content-type;
        b=RuilncXELHt9p8GRxTzdkdS9JzfbbHKoXcO9KRes07p0eEpEBSA8Cge3xx/W2fbXNvYLi2cAS01RPRRhrskQQ3nRasxx/cND9sONEglrrZiCk1EsgwC8szEhH3RK24a/Fm1736anaOyIyzk775JwXT1sywzHSqkCLwLT8phHUuU=
Date: Wed, 6 Feb 2008 21:57:38 -0500 (EST)
From: Parag Warudkar <parag.warudkar@gmail.com>
X-X-Sender: parag@mini.warudkars.net
Reply-To: parag.warudkar@gmail.com
To: Frank Mayhar <fmayhar@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [Bugme-new] [Bug 9906] New: Weird hang with NPTL and SIGPROF.
In-Reply-To: <1202345893.8525.33.camel@peace.smo.corp.google.com>
Message-ID: <alpine.LRH.1.00.0802062148480.7445@mini.warudkars.net>
References: <bug-9906-10286@http.bugzilla.kernel.org/>  <20080206165045.89b809cc.akpm@linux-foundation.org> <1202345893.8525.33.camel@peace.smo.corp.google.com>
User-Agent: Alpine 1.00 (LRH 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Feb 2008, Frank Mayhar wrote:

> On Wed, 2008-02-06 at 16:50 -0800, Andrew Morton wrote:
> > It's probably better to handle this one via email, so please send that
> > testcase vie reply-to-all to this email, thanks.
> 
> Testcase attached.
> 
> Build with
>         gcc -D_GNU_SOURCE -c hangc-2.c -o hangc-2.o
>         gcc -lpthread -o hangc-2 hangc-2.o
> 
> Run with
>         hangc-2 4500 4500

FWIW this is not reproducible on 2.6.24/x86/CentOS-51. (I tried running 
it nearly 1500 times in a loop.) Assuming those many tries are sufficient 
to reproduce this bug, there seems to be something specific to the 
environment/architecture/configuration that's necessary to trigger it. 

It might be helpful to provide full details like glibc version, compiler 
version, .config etc.

Parag
