Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbYHSVXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbYHSVXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753868AbYHSVXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:23:43 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:64165 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753862AbYHSVXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:23:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Kw+hK92stHc4bhGqP5+klUeHAS4LPlq/c9hVWsCrrkVvhVBibWJFcN999pYkJONkbA
         QgyNRhU5d976vlR0GafQbpDHQydrOWTfUJ+jIN7oQhq//fkPMkucQuq/5gE1E7iKATpg
         D9f0nD7rHlw5Eq/IZ69unetog9PxS/852zLD0=
Message-ID: <9e4733910808191423u34946955lc85caa6b2217b390@mail.gmail.com>
Date: Tue, 19 Aug 2008 17:23:40 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/2] rtc: rtc-ds1374: fix 'no irq' case handling
Cc: "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Alessandro Zummo" <a.zummo@towertech.it>,
       "Andrew Morton" <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
In-Reply-To: <20080819212937.01dfd024@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080812161733.GA32164@oksana.dev.rtsoft.ru>
	 <9e4733910808191339s28a05f90pef57961e8d24fbdb@mail.gmail.com>
	 <20080819212937.01dfd024@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > Shouldn't this be
>  >
>  > >  -       if (client->irq <= NO_IRQ)
>  >
>  > instead of
>
>
> NO_IRQ is obsolete. client->irq != is the test and IRQ numbers are
>  unsigned.

I don't know the status of these platforms....

asm-blackfin/irq.h:#define NO_IRQ ((unsigned int)(-1))
asm-mn10300/irq.h:#define NO_IRQ		INT_MAX
asm-parisc/irq.h:#define NO_IRQ		(-1)

-- 
Jon Smirl
jonsmirl@gmail.com
