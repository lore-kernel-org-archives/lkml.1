Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbXF2Vez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbXF2Vez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 17:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbXF2Ves
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 17:34:48 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:56294 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbXF2Veq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 17:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V3OvSUXWXUjm1EVrnfE6LiYeqbZ5NDCudwcDM0/qmGF7/YMvfCTbKa2RL5eJ/jkS9krrfHIEBiITNYlcjblCBIbaUjVmI1KmTRLlXYzsHgOCZE5D4vjrV5mVj4PG4+ok7dSx0DKhaDKLXHHDCk4AAiXziTGGrO11tnZcelH7gw4=
Message-ID: <d9def9db0706291434v2fe69578qf84488bfd6a965f3@mail.gmail.com>
Date: Fri, 29 Jun 2007 23:34:44 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: 2.6.22-rc6 spurious hangs
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Sattler" <tsattler@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Daniel Mack" <daniel@qanu.de>,
       "Holger Waechtler" <holger@qanu.de>
In-Reply-To: <1183152090.7089.183.camel@gaivota>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4683BF16.40905@gmx.de> <20070628150826.GA487@tv-sign.ru>
	 <4683F145.2060705@gmx.de> <4683F48F.9010603@gmx.de>
	 <20070628181044.GA613@tv-sign.ru> <4684B132.2070405@gmx.de>
	 <20070629130955.GA284@tv-sign.ru> <20070629131605.GA25964@elte.hu>
	 <20070629135848.GA332@tv-sign.ru> <1183152090.7089.183.camel@gaivota>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/29/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > Still we can't do this under cinergyt2->sem, because cinergyt2_query()
> > takes it too. This all looks very wrong to me, I hope maintaners can
> > explain.
>
> AFAIK, the driver authors are not working anymore with CinergyT2. The
> last patch we have on development tree from Holger is dated as Dec, 3
> 2004. Since them, only internal kernel API changes and a few sparse
> fixes from other contributors were applied.
>
> Also, none of the current DVB maintainers seem to have any hardware for
> testing.
>

I received a Mail a while ago that this driver is open to the
community, it duplicates some code because the developers wanted to
use this driver for testing another DVB API which never took off.
Best would be to remove the duplicated code in that driver and make it
look like all other DVB drivers.

Markus
