Return-Path: <linux-kernel-owner+w=401wt.eu-S1759629AbXFRHDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759629AbXFRHDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 03:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757402AbXFRHDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 03:03:11 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:8663 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210AbXFRHDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 03:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rI34ouUWl+S3J1UHOm+L8k0TEo6NOJ3nOkNcu1/LKc6d0x5FqiN33vc01sjKlh7E0lgt/mrCW9bdtZxeLIgema1E54rlwLU0hJQRxMMW4lSXRBkL9rggQL7H/jo4wGwDHa8Ikyht4Rzf8A5bKPlhtB7vU8noLEfWyOQ7jgj+nZk=
Message-ID: <a8e1da0706180003u35003bb6j706efc25c2b287db@mail.gmail.com>
Date: Mon, 18 Jun 2007 07:03:09 +0000
From: "dave young" <hidave.darkstar@gmail.com>
To: "Jens Axboe" <jens.axboe@oracle.com>
Subject: Re: [PATCH] cdrom_sysctl_info fix
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070618064350.GQ6149@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070614142430.GA2388@darkstar.te-china.tietoenator.com>
	 <20070615132657.GW6149@kernel.dk>
	 <20070618125811.GA1692@darkstar.te-china.tietoenator.com>
	 <20070618062722.GP6149@kernel.dk>
	 <a8e1da0706172341j3ee621efs8b2809b4fd094004@mail.gmail.com>
	 <20070618064350.GQ6149@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> > BTW, another problem, I can't find the CONFIG_CDROM option in kernel
> > config menu. Is it deperacated? If it is true, is the module part
> > still necessary?
>
> cdrom.o is a hardware independent helper module, it gets included if you
> use atapi/scsi/etc cdrom drivers. See drivers/cdrom/Makefile.
>
I know. Sorry for my bad english, I means MODULE's part maybe
deperacated, not uniform cdrom driver itsself.

For example  the module_init, module_exit and MODULE_LICENSE, I
remember it could be a standalone module in 2.4 kernels. But now seems
not possible. am I right?

Regards
dave
