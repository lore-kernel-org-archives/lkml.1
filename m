Return-Path: <linux-kernel-owner+w=401wt.eu-S1161089AbXCJP3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161089AbXCJP3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 10:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161115AbXCJP3G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 10:29:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:29297 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161089AbXCJP2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 10:28:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oi0C43xr2jqOK6iqh7SxL2Brydwqbp55U8VrMjfPkdHqUgQ/i5ULRXuErxxYLP8w+n6B90y5kcJWAV+fKVhHuSmNbui+7O2yI25hV3b0HokhlZPjGoJN7yJXlzgpeSZ/NlZ/prS6dPm8K+RviaJm1CChoHFdyKOD19GSr2gbMYQ=
Message-ID: <b637ec0b0703100728i5a38e17boe370c86c02791e02@mail.gmail.com>
Date: Sat, 10 Mar 2007 16:28:52 +0100
From: "Fabio Comolli" <fabio.comolli@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [git patches] libata (and devres) fixes
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070309234839.2070a265@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070309163148.GA12848@havoc.gtf.org>
	 <b637ec0b0703091324q7f15fddbpc8c24b4e1131e3f4@mail.gmail.com>
	 <20070309234839.2070a265@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe KERN_DEBUG instead of KERN_ERR?


On 3/10/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > scsi1 : ata_piix
> > ata2: port disabled. ignoring.
> > ata2: reset failed, giving up    <--- THIS IS NEW.
> >
> > However, I think it's just bogus as there is ata2 is disabled on this laptop.
>
> This is expected behaviour and it is what every controller except the
> PIIX has done for some time. I'm not sure its perfect but we could return
> 0 from the -ENOENT case in ata_eh_reset() if that is preferred.
>
>
