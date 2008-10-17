Return-Path: <linux-kernel-owner+w=401wt.eu-S1756247AbYJQSq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbYJQSq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 14:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYJQSqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 14:46:49 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:31459 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbYJQSqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 14:46:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RUYDQkSLKJOqL51r6FQFeDdsO8a/RxehZPaKUEFAs7gDbZQpHiqJ3SfFkOgUA1Vr7x
         JQ/97Tsdfb+vR9rpLRN9MsTLChjntSOAy/V7vyo2UYo3Lox3FUmJvM8KRtoaiKkrnOYf
         h9133Sb41v54WPBows2lsc++d32GY0781hzz4=
Message-ID: <c49e66200810171146u5915c6b8w95174f97cdc92c89@mail.gmail.com>
Date: Fri, 17 Oct 2008 20:46:46 +0200
From: "Pieter Steyn" <pieterste@gmail.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: r6080 driver not working.
Cc: tech@dmp.com.tw
In-Reply-To: <c49e66200810170750s2d06d035m28ce5da3e6ca9c38@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c49e66200810170750s2d06d035m28ce5da3e6ca9c38@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh, sorry.  I obviously meant the r6040 driver. :)

Cheers,
Pieter Steyn

On Fri, Oct 17, 2008 at 4:50 PM, Pieter Steyn <pieterste@gmail.com> wrote:
> Hi,
>
> I cannot get the r6080 driver working properly in either 2.6.26 or
> 2.6.27.  It compiles, and loads fine enough, but as soon as I try and
> bring up the device I get a 'resource is in use and busy' message.
>
> I've tried using both the driver supplied by the kernel and the one
> linked on their website (with some modifications to make it compile :
>
> r6040# diff r6040.c r6040.orig
> 277a278
>>       SET_MODULE_OWNER(dev);
> 380c381
> <       i = request_irq(dev->irq, &r6040_interrupt, IRQF_SHARED,
> dev->name, dev);
> ---
>>       i = request_irq(dev->irq, &r6040_interrupt, SA_SHIRQ, dev->name, dev);
> 1079c1080
> <       return pci_register_driver (&r6040_driver);
> ---
>>       return pci_module_init (&r6040_driver);
>
> Networking works with 2.6.21 using the driver from their website and
> the above patch.
>
> I've cc'ed in tech support to the manufacturer.
>
> Thanks, and sorry if the information isn't much to work with...but
> since I don't get any errors other than device being busy I'm not sure
> what to do from here.
>
