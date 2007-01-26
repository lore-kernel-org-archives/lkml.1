Return-Path: <linux-kernel-owner+w=401wt.eu-S1030647AbXAZEqq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030647AbXAZEqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 23:46:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030650AbXAZEqp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 23:46:45 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:61543 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030647AbXAZEqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 23:46:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Eew8N2ntsHuv9aTrevd3APn1Kncqq/RoOVAV0VXOfFDEAva3/b3p0tW3Kcdo4sfO4p2ZRrzVbj0lwQ/ig3oqD0FvZ2RRF08wEdDUSz3eaMavEgzS/rR2Cv11W88iMx5GKerOXUMfHg2iBCtBB2fx+msQbMs3S5KJ4IZ9kpXZ4g4=
Message-ID: <a71293c20701252046o73fabcb9v611dedbb6f6b90e3@mail.gmail.com>
Date: Thu, 25 Jan 2007 23:46:38 -0500
From: "Stephen Evanchik" <evanchsa@gmail.com>
To: "Luming Yu" <luming.yu@gmail.com>
Subject: Re: SATA ahci Bug in 2.6.19.x
Cc: "Stefan Priebe - FH" <studium@profihost.com>, linux-kernel@vger.kernel.org
In-Reply-To: <3877989d0701251925i8bbc09emd8dcad8d098195d2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45B46FA0.2060901@profihost.com>
	 <a71293c20701220600v426f0efdyc23dd945852f71c0@mail.gmail.com>
	 <3877989d0701251925i8bbc09emd8dcad8d098195d2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/25/07, Luming Yu <luming.yu@gmail.com> wrote:
> From the log:
> 2.6.18.3:
> ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 217
> 2.6.20-rc5:
> "ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 21 (level, low) -> IRQ 21"
>
> Sounds like acpi interrupt configure problem. Please try acpi=off first.


Still does not recognize the SATA device (and the machine fails to
come up). I tested this with 2.6.19.2, 2.6.20-rc5 and -rc6 this
evening. I am going to build a vanilla 2.6.18 and see if that still
works as I am currently running an FC5 kernel.

Stephen


-- 
Stephen Evanchik
http://stephen.evanchik.com
