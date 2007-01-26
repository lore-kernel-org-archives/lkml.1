Return-Path: <linux-kernel-owner+w=401wt.eu-S1030748AbXAZFWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030748AbXAZFWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 00:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030747AbXAZFWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 00:22:40 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:46866 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030748AbXAZFWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 00:22:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=N8h5Wg6EmwKuydEokmoL3yCIYGzwwSgwdp+wbIdg2BSuxsF5xSI8cVuEmS5RTBpyDWOUocWSVIcht4FUg6U1vcuE+BksLJbYCHPPq9rjylVb/36JMEsFZdxdAl6BHvaZkgFj5I26Jogp3ljNtqDDQTc+tpfL+XODvBAN4C/SetU=
Message-ID: <3877989d0701252122s7e5ad92fo5496daf566fd9f97@mail.gmail.com>
Date: Fri, 26 Jan 2007 13:22:39 +0800
From: "Luming Yu" <luming.yu@gmail.com>
To: "Stephen Evanchik" <evanchsa@gmail.com>
Subject: Re: SATA ahci Bug in 2.6.19.x
Cc: "Stefan Priebe - FH" <studium@profihost.com>, linux-kernel@vger.kernel.org
In-Reply-To: <a71293c20701252046o73fabcb9v611dedbb6f6b90e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B46FA0.2060901@profihost.com>
	 <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
	 <3877989d0701251925i8bbc09emd8dcad8d098195d2@mail.gmail.com>
	 <a71293c20701252046o73fabcb9v611dedbb6f6b90e3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/26/07, Stephen Evanchik <evanchsa@gmail.com> wrote:
> On 1/25/07, Luming Yu <luming.yu@gmail.com> wrote:
> > From the log:
> > 2.6.18.3:
> > ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 217
> > 2.6.20-rc5:
> > "ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21"
> >
> > Sounds like acpi interrupt configure problem. Please try acpi=off first.
>
>
> Still does not recognize the SATA device (and the machine fails to
> come up). I tested this with 2.6.19.2, 2.6.20-rc5 and -rc6 this
> evening. I am going to build a vanilla 2.6.18 and see if that still
> works as I am currently running an FC5 kernel.
>
Is there any difference in dmesg with acpi=off?
what is your sata driver?
