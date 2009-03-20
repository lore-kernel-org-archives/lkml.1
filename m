Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZCTIaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZCTIaF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 04:30:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487AbZCTI3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 04:29:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:20224 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712AbZCTI3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 04:29:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=krKqRpJ7zZT2NNgzaljUPw+DRWJBV10LkyqEROWE32QULWgOUtMonPh/1KtYG2cxY
	q4z1EyQWIXpLLYcRfwFpg==
MIME-Version: 1.0
In-Reply-To: <20090320.012020.100200198.davem@davemloft.net>
References: <9c0b8b730903200115i7ae4512di97418958e05f6a0e@mail.gmail.com>
	 <20090320.012020.100200198.davem@davemloft.net>
Date: Fri, 20 Mar 2009 16:29:38 +0800
Message-ID: <9c0b8b730903200129t6b4f9c29s1ee036bf32d2d15e@mail.gmail.com>
Subject: Re: [PATCH] crypto/scatterwalk.c to skip unnecessary 
	flush_dcache_page() calls which may cause kernel panic
From: =?Big5?B?Q2h1bmctWWloIFdhbmcgKKT9sVLFdCk=?= <cywang@google.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's great. Thanks for the info.

2009/3/20 David Miller <davem@davemloft.net>:
> From: Chung-Yih Wang (¤ý±RÅt) <cywang@google.com>
> Date: Fri, 20 Mar 2009 16:15:16 +0800
>
>> Below is my patch for fixing this bug for  CONFIG_DEBUG_VM=y.
>
> This exact change is already in the tree, and it's been there
> for at least a month.
>
>
