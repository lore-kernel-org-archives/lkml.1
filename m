Return-Path: <linux-kernel-owner+w=401wt.eu-S933834AbZHEAG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933834AbZHEAG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 20:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933822AbZHEAGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 20:06:25 -0400
Received: from mail-qy0-f196.google.com ([209.85.221.196]:64937 "EHLO
	mail-qy0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530AbZHEAGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 20:06:25 -0400
MIME-Version: 1.0
In-Reply-To: <20090804.115701.250978139.davem@davemloft.net>
References: <1248912621.13447.12.camel@merlyn>
	 <20090803.212323.256579233.davem@davemloft.net>
	 <6c039e090908040036j38666152y2db1d4c55529eaff@mail.gmail.com>
	 <20090804.115701.250978139.davem@davemloft.net>
Date: Wed, 5 Aug 2009 08:06:25 +0800
Message-ID: <6c039e090908041706p6f06ac55ja796ac53855e829a@mail.gmail.com>
Subject: Re: [PATCH] net: Keep interface binding when sending packets with 
	ipi_ifindex = 0
From: =?UTF-8?B?Q2hpYS1jaGkgWWVoICjokYnlrrbpvYop?= <chiachi@android.com>
To: David Miller <davem@davemloft.net>
Cc: john.dykstra1@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/5 David Miller <davem@davemloft.net>:
> I think we really cannot change behavior here.  If the user specifies
> "0" in ipi_ifindex we must respect that in ipc->oif.  This is an
> override, and the ability to override is the very purpose of this
> control message.
>
> Even GLIBC makes use of that case of specifying "0" in ipi_ifindex.
> We must respect it.
>
> I'm not applying any of these patches, sorry.
>

If you treat ipi_ifindex as an override, do you want to do that in
ipi6_ifindex as well? Also, CAP_NET_RAW check for SO_BINDTODEVICE
becomes meaningless in this case.

I did not find the usage of ipi_ifindex in glibc. It would be great if
you can give me some pointers. Thanks for your help.

Chia-chi
