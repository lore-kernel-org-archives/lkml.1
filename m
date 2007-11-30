Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXK3KaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXK3KaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 05:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXK3K34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 05:29:56 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:29338 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbXK3K34 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 05:29:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xT8Zt/Dh91to8uTb/yCH5P0hj+5B6SPn+QBZZTxat88fYSa1N+QeHVlWlbg17/hn4Xik9h/HJxFyQYnX+83VaWLTryOQ2+v/7Zpy1Xde4D3BxapUF6R2p1JBwJDJ6UsgaT8umD+ucL6t2wwZbs5o10kh76NaOdcXrVlkJCDfS78=
Message-ID: <9b06e8d20711300229r1ed570bfi9ecbb6466fd0a0ab@mail.gmail.com>
Date: Fri, 30 Nov 2007 11:29:55 +0100
From: "=?ISO-8859-1?Q?Lo=EFc_Greni=E9?=" <loic.grenie@gmail.com>
To: Ben.Crowhurst@stellatravel.co.uk
Subject: Re: Kernel Development & Objective-C
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <474EAD18.6040408@stellatravel.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <474EAD18.6040408@stellatravel.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/29, Ben Crowhurst <Ben.Crowhurst@stellatravel.co.uk>:
> Has Objective-C ever been considered for kernel development?
>
> regards,
> BPC

   No, it has not. Any language that looks remotely like an OO language
  has not ever been considered for (Linux) kernel development and for
  most, if not all, other operating systems kernels.

    Various problems occur in an object oriented language. One of them
  is garbage collection: it provokes asynchronous delays and, during
  an interrupt or a system call for a real time task, the kernel cannot
  wait. Another is memory overhead: all the magic that OO languages
  provide take space in memory and Linux kernel is used in embedded
  systems with very tight memory requirements.

    Lots of people will think of better reasons why ObjC is not used...

        Loïc Grenié
