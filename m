Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbZCMSib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbZCMSib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 14:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbZCMSiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 14:38:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:20855 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859AbZCMSiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 14:38:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=iZ47OjhlzzwtaS0hSwe+VglREW1MbSds6nOdOmfZk0mPM+Dig5szS3qCEXK2xM8FqN
         SRr6YmVT5yT38aPZffJgjnf2wcVeMNOu+r4PtMKb1tcvhnny7/92egMoKl289hXonKUX
         8MYwnwjztyoprR2/hNe7L0msHn01LWpjHp6wk=
MIME-Version: 1.0
In-Reply-To: <20090313.100802.67201749.davem@davemloft.net>
References: <59f1f0cb0903130025k31cc2c9fud865dd776534c2bd@mail.gmail.com>
	 <20090313.100802.67201749.davem@davemloft.net>
Date: Fri, 13 Mar 2009 11:38:14 -0700
Message-ID: <59f1f0cb0903131138s1012ef9q94a67d212e905296@mail.gmail.com>
Subject: Re: Network throughput (localhost)
From: Aki Niimura <akineko@gmail.com>
To: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

Thank you for your prompt response to my posting.
I have changed my program temporarily to use AF_UNIX and tested the performance.
I got approx 20% throughput improvement in all testing conditions.
Thank you!

However, even with the use of AF_UNIX, the localhost throughput of
Solaris/x86 is still around 30% faster than Linux's AF_UNIX throughput
(using the same h/w).
I like the way Solaris did because I don't need to change my program
as my program may need to send packets to another machine rather than
another CPU next to.
Hope Linux will incorporate such scheme in the future.

Best regards,
Aki Niimura

On Fri, Mar 13, 2009 at 10:08 AM, David Miller <davem@davemloft.net> wrote:
> From: Aki Niimura <akineko@gmail.com>
> Date: Fri, 13 Mar 2009 00:25:48 -0700
>
>> Any suggestions will be greatly appreciated.
>
> Use AF_UNIX sockets if you want optimal performance.
>
> Solaris treats TCP connections over localhost specially,
> and we have no plans to add that optimization any time
> soon.
>
