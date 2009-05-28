Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbZE1DqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbZE1DqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 23:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759207AbZE1DqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 23:46:08 -0400
Received: from ozlabs.org ([203.10.76.45]:45574 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721AbZE1DqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 23:46:07 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: cl@linux-foundation.org
Subject: Re: [my_cpu_ptr 1/5] Introduce my_cpu_ptr()
Date: Thu, 28 May 2009 13:16:01 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
References: <20090527180635.008102701@gentwo.org> <20090527180714.834691580@gentwo.org>
In-Reply-To: <20090527180714.834691580@gentwo.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905281316.01923.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 03:16:59 am cl@linux-foundation.org wrote:
> my_cpu_ptr(xx) = per_cpu_ptr(xx, smp_processor_id).

I had this implemented earlier as as get_cpu_ptr()/__get_cpu_ptr(), to match 
get_cpu_var() / __get_cpu_var().

But other than that nomenclature quibble, it looks fine!

Thanks,
Rusty.
