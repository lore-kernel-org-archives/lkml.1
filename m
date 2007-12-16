Return-Path: <linux-kernel-owner+w=401wt.eu-S1761546AbXLPInm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761546AbXLPInm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 03:43:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXLPInc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 03:43:32 -0500
Received: from yumi.tdiedrich.de ([85.10.210.183]:57184 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbXLPInb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 03:43:31 -0500
Date: Sun, 16 Dec 2007 09:38:28 +0100
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       dada1@cosmosbay.com
Subject: Re: dst cache overflow
Message-ID: <20071216083828.GA512@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-net@vger.kernel.org,
	linux-kernel@vger.kernel.org, dada1@cosmosbay.com
References: <20071214172945.GA10809@yamamaya.is-a-geek.org> <E1J3QWn-0006sJ-00@gondolin.me.apana.org.au> <20071215100857.GA29839@yamamaya.is-a-geek.org> <20071216073533.GA2706@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071216073533.GA2706@gondor.apana.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Sat, Dec 15, 2007 at 11:08:58AM +0100, Tobias Diedrich wrote:
> >
> > Hmm, how do I look for that, if netstat doesn't look suspicous?
> 
> Thanks.  What does /proc/net/sockstat show?

ranma@oni:~$ cat /proc/net/sockstat
sockets: used 143
TCP: inuse 16 orphan 0 tw 4 alloc 21 mem 1
UDP: inuse 8
UDPLITE: inuse 0
RAW: inuse 0
FRAG: inuse 0 memory 0

HTH,

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
