Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZCVATn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZCVATn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 20:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753954AbZCVATa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 20:19:30 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:42694 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945AbZCVAT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 20:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=s8LrgbJYzKlFNX5O9AAJNI2g1sGSKNsp5W7B14UObZIoGA3qwoqv9w0n5g1cXGMeVr
         3hHPGY+62Gn/kph1cLmuqJbbD+wt7siVUjdv7obWFHnZl57tAZIqnxjGvY1X5fXO9oIx
         Q9woY1cKKYDWbAN1sOmqq1T3oK6fyIrx0OMww=
MIME-Version: 1.0
In-Reply-To: <20090321.165950.248659848.davem@davemloft.net>
References: <20090320115838.GA26371@orion>
	 <20090321.165950.248659848.davem@davemloft.net>
Date: Sun, 22 Mar 2009 03:19:25 +0300
Message-ID: <a4423d670903211719m76baeab0k51f054058d6f5134@mail.gmail.com>
Subject: Re: [PATCH] Phonet:fix build problem
From: Alexander Beregalov <a.beregalov@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kyle@mcmartin.ca,
       linux-parisc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/3/22 David Miller <davem@davemloft.net>:
> From: Alexander Beregalov <a.beregalov@gmail.com>
> Date: Fri, 20 Mar 2009 14:58:38 +0300
>
>> net/phonet/pep.c: In function 'pipe_rcv_status':
>> net/phonet/pep.c:262: error: lvalue required as left operand of assignment
>>
>> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
>
> What platform hits this problem?
>
> I think that platform's atomic_add() implementation should
> be fixed instead.

It is parisc, CC added.
