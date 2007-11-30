Return-Path: <linux-kernel-owner+w=401wt.eu-S934519AbXK3Rjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519AbXK3Rjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 12:39:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbXK3Rjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 12:39:41 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:33135 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbXK3Rjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 12:39:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=C96G4fzctjbl4RbbGUqXN0VnjpDnpYnlQexvYAoloFEDprnFTrfRb+hOoueS32O79IZm+RCnrtne0i9N+4UZ6G0jDViRbkE8oroj3t8dYh4mqT++G9TVN2Y8PLRJfOTOnKZBc0NSQ8v3GA2e541+bxRDMDQlyzxpw/FUrYyprC8=
Message-ID: <40dfeece0711300939l71b1ae2bq5fbd1ae21ec1d055@mail.gmail.com>
Date: Fri, 30 Nov 2007 17:39:37 +0000
From: "Chris Rutherford" <chrismrutherford@googlemail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ldd irq problem
In-Reply-To: <474FE681.9080101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <40dfeece0711291447m2efa4f40i5c2c22a4273ecbc0@mail.gmail.com>
	 <40dfeece0711300128s731b3227xaa0b5982193e4b12@mail.gmail.com>
	 <474FE681.9080101@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

many thanks, the following says it all..

box:/home/chris/work/fpgaio# grep sha1 /proc/interrupts
 12:   14669741          XT-PIC  sha1 handler


On Nov 30, 2007 10:31 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 11/30/2007 10:28 AM, Chris Rutherford wrote:
> > Helo lkml,
> >
> > I'm trying to write a LDD but I have got a bug.  Any ideas what i
> > might be doing wrong?
> >
> > ret = request_irq(12, handler, SA_INTERRUPT | SA_SHIRQ, "sha1
> > handler", DEVICE_NAME);
> > printk (KERN_INFO "req irq %d \n", ret);
> > enable_irq(12);
>
> enable_irq is opposite of disable_irq(_nosync), you don't need to call it in
> probe function and in most cases you don't need it at all.
>
> regards,
> --
> Jiri Slaby (jirislaby@gmail.com)
> Faculty of Informatics, Masaryk University
>
