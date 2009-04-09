Return-Path: <linux-kernel-owner+w=401wt.eu-S1764336AbZDIOpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764336AbZDIOpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757461AbZDIOp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:45:26 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:60572 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761389AbZDIOpY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:45:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=c27UtGUkHjwG0DgMyG08/py48v4YufkSReZTrSdU9BYJio8ZmQkC4Vy+vV4dyZ7/pk
         iFGas4UyNGYSPGF6MjIcupAt6eiMEfEzud+AnzkAn3kNHe7+Oqhls3knYZJ/1BimS21v
         Zeo7U7/AyaDirTGCB+PIP+4nfO8jb9XMGAFlM=
MIME-Version: 1.0
In-Reply-To: <20090409041746.GF20692@elte.hu>
References: <d82e647a0904050253n31bd2654s9b216465eec4d038@mail.gmail.com>
	 <200904081247.08712.rusty@rustcorp.com.au>
	 <1239194906.13185.93.camel@twins>
	 <200904090915.18644.rusty@rustcorp.com.au>
	 <20090409041746.GF20692@elte.hu>
Date: Thu, 9 Apr 2009 22:45:22 +0800
Message-ID: <d82e647a0904090745j15e0e4nbb517c62c8af9ab5@mail.gmail.com>
Subject: Re: pm-hibernate : possible circular locking dependency detected
From: Ming Lei <tom.leiming@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/9 Ingo Molnar <mingo@elte.hu>:
>
> That's now upstream as per:
>
>  6b44003: work_on_cpu(): rewrite it to create a kernel thread on demand
>
> So re-checking whether the warning still triggers with latest -git
> would be nice.

I don't find this warning  any longer  during pm-hibernate 2.6.30-rc1, which
have __not__ include 6b44003.

>
>        Ingo
>



-- 
Lei Ming
