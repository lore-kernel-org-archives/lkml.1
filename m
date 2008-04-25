Return-Path: <linux-kernel-owner+w=401wt.eu-S1765182AbYDYSSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765182AbYDYSSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 14:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757831AbYDYSSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 14:18:16 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:23012 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760869AbYDYSSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 14:18:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fD0NckdeydIbYSi35bzHFvlhc6oiSLg5nTr0Ij/mZJzGtFDwN3Np+otSwVBk+Nh30t3VXLBuZlpPHwUKC0nPgjp7+sGV7Dr4ZbDv0+RKEIOsPNC8dTI7A/WIt9ub1PdmE+zgHOCDR7BdR+tX/Louu2675BRs39+N+iPSFYn4z+U=
Message-ID: <ca2dc2820804251118j625abb76j100d165aee18a7c8@mail.gmail.com>
Date: Fri, 25 Apr 2008 20:18:13 +0200
From: "Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: Talking to parallel port in 2.6 kernel without using parport
Cc: "Kathy Frazier" <kfrazier@daetwyler-rd.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20080425181219.61e29b1f@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <009501c89e28$3d7530f0$b85f92d0$@com>
	 <20080414133937.7080d30d@core> <006f01c8a4a7$82e37ea0$88aa7be0$@com>
	 <20080425181219.61e29b1f@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Can you tell me what I am missing?  Where can I get the actual source code
>  > that goes with this version to further unravel this?

About two years ago (~2.6.18) I wrote one driver that needed exclusive
access to the parallel port and, like this time, Alan Cox guided me
(thank you Alan!). If you want, you can check the code at
drivers/auxdisplay/ks0108.c. I tested it as of 2.6.25 and worked fine,
so it could be a good reference for you. In addition, the code is
pretty straightforward!

>
>  To be honest this area of the kernel hasn't changed much over recent
>  times. Let me know if you can't figure out what is going on.
>

Right, I haven't had to change the code since 2.6.18.

--
Miguel Ojeda
