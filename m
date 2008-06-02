Return-Path: <linux-kernel-owner+w=401wt.eu-S1756113AbYFBSq5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113AbYFBSq5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 14:46:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753444AbYFBSqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 14:46:40 -0400
Received: from web50106.mail.re2.yahoo.com ([206.190.38.34]:27411 "HELO
	web50106.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753163AbYFBSqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 14:46:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=xtebVpkDj9gXWE39GoO/4idjxa4n1PJnLN5Elcx1BOgrWcOY/m4xUUOxbuBNJSnovIMZNItCX9n9VLJwMKIhQU88wQZri2+ryGUrNbXi3MQHU2nVD95j4oBvsJf4J4E7boi9s3vfh+1ktRyEokWTF32hf9pRbkMiv1gnxKUlb4k=;
X-YMail-OSG: qH36TuwVM1kaUgjsYirxEkjfWru_h5xRnAmfR7DXpU7iaSsI611pMLJzZqQGXAISvmHkHRHa5LcVvq7huAS16Ime4A8aykKMhGUZ3ytFfPIA2V4RRoDdYs4JSQ--
Date: Mon, 2 Jun 2008 11:46:37 -0700 (PDT)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: EDAC i5000 MC0: NON-FATAL ERRORS
To: Jack Howarth <howarth@bromo.msbb.uc.edu>, linux-kernel@vger.kernel.org
In-Reply-To: <20080530165550.GA23698@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <534708.90379.qm@web50106.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:

>    I am seeing the following errors on a Fedora 7 x86_64 linux box,
> running on a Tyan Tempest i5000XL motherboard, after upgrading from
> kernel-2.6.25-14.fc9.x86_64 to kernel-2.6.25.3-18.fc9.x86_64...
> 
> May 25 04:30:56 fourier kernel: EDAC i5000 MC0: NON-FATAL ERRORS Found!!! 1st NON-FATAL Err Reg=
> 0x10000
> May 25 04:30:56 fourier kernel: EDAC MC0: CE row 1, channel 0, label "": (Branch=0 DRAM-Bank=3
> RDWR=Read RAS=14339 CAS=672, CE Err=0x10000)
> 
> These messages occur about once an hour and are always for the same DRAM-Bank.
> I've not been able to find any memory errors when running memtest86 with or
> without ECC checking being enabled. Are there any known issues with the
> EDAC support in the kernel that might cause false positives like this?
> The errors are always marked as non-fatal and are for reads. Also, does
> anyone know how this code numbers ram banks? Is the first ram bank considered
> 0 or 1 by this code? Thanks in advance for any clarifications.
>                     Jack

Yes, it is a known false positive bug.

The hardware has some type of error which it calls NON-FATAL, and the driver is TOO verbose in
reporting that event. I am working on a patch to quiet that down

thanks

doug t


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


W1DUG
