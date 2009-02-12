Return-Path: <linux-kernel-owner+w=401wt.eu-S1760650AbZBLVk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760650AbZBLVk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZBLVkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:40:09 -0500
Received: from ozlabs.org ([203.10.76.45]:43519 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZBLVkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:40:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] Update jhash.h with the new version of Jenkins' hash
Date: Thu, 12 Feb 2009 13:28:42 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org
References: <alpine.DEB.2.00.0902111107480.15665@blackhole.kfki.hu>
In-Reply-To: <alpine.DEB.2.00.0902111107480.15665@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902121328.43749.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 11 February 2009 20:49:20 Jozsef Kadlecsik wrote:
> Hi,
> 
> The current jhash.h implements the lookup2() hash function by Bob Jenkins. 
> However, lookup2() is outdated as Bob wrote a new hash function called 
> lookup3(). The new hash function
> 
> - mixes better than lookup2(): it passes the check that every input bit 
>   changes every output bit 50% of the time, while lookup2() failed it.
> - performs better: compiled with -O2 on Core2 Duo, lookup3() is 20-40% 
>   faster than lookup2() depending on the key length.

Hi Joszef,

My concern was that it's also bigger (and we inline it).  Performance is
pretty much a wash since we so rarely hash more than a few words.

Any stats on code size changes?
Rusty.
