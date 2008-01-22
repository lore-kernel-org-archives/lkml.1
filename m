Return-Path: <linux-kernel-owner+w=401wt.eu-S1756872AbYAVWn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872AbYAVWn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 17:43:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753437AbYAVWnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 17:43:16 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:25830 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbYAVWnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 17:43:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jBP40jw1sr3zNzGz5XvVlnsXUWNYblMsjPJP8g/Vd+5atUDSkoTmu7wPGoXyyrzORs9PcS64rlCvFhYOz+bq9Bvn22fg2qN1c6mnxWeHIYJeVFjW0/2rB2v7dulpp1DKrez96yluq2kanlLhJz07/fhNGlH8xzc2xD0J1+c1x0I=
Message-ID: <8bd0f97a0801221443k1442046br4d6a6c8e1be7e666@mail.gmail.com>
Date: Tue, 22 Jan 2008 17:43:13 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] procfs: constify function pointer tables
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
       "Bryan Wu" <bryan.wu@analog.com>, "Mikael Starvik" <starvik@axis.com>,
       "David Howells" <dhowells@redhat.com>,
       "Hirokazu Takata" <takata@linux-m32r.org>,
       "Geert Uytterhoeven" <geert@linux-m68k.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kyle McMartin" <kyle@parisc-linux.org>,
       "Matthew Wilcox" <matthew@wil.cx>, "Chris Zankel" <chris@zankel.net>
In-Reply-To: <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <54038cd4f87a03884e4f59f8f3697889dfb63c54.1201030614.git.jengelh@computergmbh.de>
	 <Pine.LNX.4.64.0801222055440.5722@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 22, 2008 3:00 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> This touches so many different places that I did not feel like creating
> a miniscule patch for each architecture. I hope that is ok.

there is a linux-arch alias so you dont have to look up every
maintainer yourself ;)

>  arch/blackfin/kernel/setup.c  |    2 +-

Blackfin changes look fine, thanks

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike
