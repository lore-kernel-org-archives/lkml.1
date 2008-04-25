Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbYDYMPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbYDYMPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 08:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbYDYMPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 08:15:24 -0400
Received: from rv-out-0708.google.com ([209.85.198.249]:41248 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753770AbYDYMPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 08:15:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Ym1wCNXo1u80YvAC4pAVnnqaRviydeUUO7qQYbpgyfI+BnJr4/04Pj7kX5VuDdp5zwM1VNbkbVjEn1bYZ1SjDS7sBPmWVQMDrkPMNMwgEqhLI9kqreIEpyzqGfhDNwzax7DUvtGpv9Tm68xFEwVwPBTA/RDC7RCAALYPJpl4vfA=
Message-ID: <c4e36d110804250515u713775bdjbb7bfac2d0e83d96@mail.gmail.com>
Date: Fri, 25 Apr 2008 14:15:22 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Cc: jirislaby@gmail.com, torvalds@linux-foundation.org, mingo@elte.hu,
       rjw@sisk.pl, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, penberg@cs.helsinki.fi, clameter@sgi.com
In-Reply-To: <20080425.021301.193689806.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4811090A.9030809@gmail.com>
	 <alpine.LFD.1.10.0804241539150.2779@woody.linux-foundation.org>
	 <4812108D.6020103@gmail.com>
	 <20080425.021301.193689806.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/4/25, David Miller <davem@davemloft.net>:
> From: Jiri Slaby <jirislaby@gmail.com>
>
> Date: Fri, 25 Apr 2008 19:10:37 +0200
>
>
>  > I'm going to bisect it, will be back in few hours ;).
>
>
> Thanks for all of this hard work and investigation Jiri!
>

Well just to show it's not happing only to Jiri:

It's actually shows immediately on my box after suspend-resume...

 ./testf     (Jiri's test code from this thread)
alloced 0
WHAT THE HELL (015130f8):
ff00aa00deadcc22 ff00aa00f0adcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22 ff00aa00deadcc22
ff00aa00deadcc22 ff00aa00deadcc22
