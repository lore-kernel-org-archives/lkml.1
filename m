Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbXLLAKf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbXLLAKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 19:10:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXLLAK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 19:10:27 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:62370 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXLLAK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 19:10:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=X8WX5+cV+iKIzXX4Yh3t9XuLGIi112fnGG3k6v9C6zd+L/HOQR5FjE6Uf2sc/2RBzVLtd6XjJrU3ido255pKeuD42kZguPVAhx2tVsZv7qkwpenpD0oQAQVsk47DwpOba8Ubzn4ae9A+hwIwka0YgKhBVpCoftjlrUX7OidHBgU=
Date: Wed, 12 Dec 2007 01:09:28 +0100
From: Alejandro Riveira =?UTF-8?B?RmVybsOhbmRleg==?= 
	<ariveira@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz, andi@firstfloor.org,
       rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>, david@davidnewall.com,
       hpa@zytor.com, john@stoffel.org, linux-os@analogic.com
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212010928.3c763ccd@Varda>
In-Reply-To: <475F227D.7050203@keyaccess.nl>
References: <475F1DC6.5090403@keyaccess.nl>
	<20071212004316.079e3a05@Varda>
	<475F227D.7050203@keyaccess.nl>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

El Wed, 12 Dec 2007 00:51:25 +0100
Rene Herman <rene.herman@gmail.com> escribió:

> On 12-12-07 00:43, Alejandro Riveira Fernández wrote:
> 
> >  On my AMD 3800 X2 (2000MHz) ULi M1697 2.6.24-rc5 i get:
> > 
> >  cycles: out 1844674407370808, in 1844674407369087
> >  
> > It is not constant but variations are not significant afaics
> 
> Eh, oh, I guess you need to compile as a 32-bit binary...
 
 I tried without -O2 as Nigel Cunningham...

 cycles: out 1562, in 865
 cycles: out 1562, in 866
 cycles: out 1555, in 858
 cycles: out 1562, in 866
 
 With -m32 -O2
 cycles: out 1566, in 876
 cycles: out 1555, in 865
 cycles: out 1594, in 931
 cycles: out 1559, in 874
 ...
> 
> Rene.
