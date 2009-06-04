Return-Path: <linux-kernel-owner+w=401wt.eu-S1752949AbZFDI1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbZFDI1s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 04:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757369AbZFDI12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 04:27:28 -0400
Received: from smtp106.sbc.mail.gq1.yahoo.com ([67.195.14.109]:36613 "HELO
	smtp106.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757125AbZFDI1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 04:27:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VyExsUemHX9F+g4Xu1oT1lPFt75zw522VEUIJPi1PCVnDAlwbQbxRHDRAo2y2D53Zqa/7aDx7Dr1jxE4dD/YL02vtgiC9FJgxjBEpaGd6GsAfcOl9aVpUyYxo7MCEqpI0suFfTD467SQ0WlUTdgWlOTOlACaWlxCCBXERevRY/k=  ;
X-YMail-OSG: XzUBcRgVM1nB3rDCj1H4WHhfBmqI8VZAUTb5jHm4eosHpfNJ56DtZFJDOkXdOL873yiIaUU6veg3siIF6n1ebh3eT4cB5zrjQwr46J2ELaUIXSjxxse7_zjSpxPKVMdLbZzJlwTlFePHqSLu.L0m57PVurA6e66AQOt4RLybRQWR.oL7lzxPzJnn4tuuJayfaLhoI.iqMI9qLC3uBG1qN7YotVurPEJoDyPToJAQn9uoMZfy3DIjzR2dJ5Fp8E_yBG5whhisBXiRjRZDJvgiOIZPEF8aiO5aUN2.B4adO_m7B1Z6O3s-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH] gpio sysfs: add a "toggle" value
Date: Thu, 4 Jun 2009 01:27:24 -0700
User-Agent: KMail/1.9.10
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1244017019-28163-1-git-send-email-vapier@gentoo.org> <20090604005435.d3671419.akpm@linux-foundation.org> <8bd0f97a0906040116v659d0cdetaff267f4241be175@mail.gmail.com>
In-Reply-To: <8bd0f97a0906040116v659d0cdetaff267f4241be175@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906040127.24740.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 June 2009, Mike Frysinger wrote:
> >
> > A suitable place to document this is Documentation/gpio.txt.
> 
> yes, but i wanted to make sure David didnt reject the idea before i
> spend time writing documentation.

My initial reaction was that the function is somewhat superfluous,
so having a use case in the patch comment would be good:  why
can't userspace do the toggle itself?

On the other hand, I find it hard to object to such a small feature.
If that's the worst feature bloat in Linux this year, we're overdue
for a big party.  ;)


