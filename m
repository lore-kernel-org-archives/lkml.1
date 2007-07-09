Return-Path: <linux-kernel-owner+w=401wt.eu-S1755134AbXGIRvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbXGIRvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbXGIRvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:51:14 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:42893 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbXGIRvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:51:13 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: mikie <mikie.pl@gmail.com>
Subject: Re: understanding firmware loader for speedtouch (kernel 2.6.21.5)
Date: Mon, 9 Jul 2007 19:51:18 +0200
User-Agent: KMail/1.9.7
Cc: "Indan Zupancic" <indan@nul.nu>, "Kay Sievers" <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org
References: <ca35ce500707060554v71ebdca3k8ef18e4c0a44c9cb@mail.gmail.com> <200707091923.38577.duncan.sands@math.u-psud.fr> <ca35ce500707091041r1e660ca8h317e4936089d59aa@mail.gmail.com>
In-Reply-To: <ca35ce500707091041r1e660ca8h317e4936089d59aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707091951.18537.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 

> > Is it actually running in isochronous mode?  (It prints some messages
> > about this).
> 
> This is what I get:
> root@srv:/# cat /sys/module/speedtch/parameters/enable_isoc
> Y
> 
> I think it means it confirms the isochronous mode is working.
> Especially that I modified the source of the speedtch.c so that the
> enable_isoc is on by default.

if you turn on isochronous mode, but there is some reason it can't be
used you get the message: "isochronous transfer not supported - using bulk".

Ciao,

Duncan.
