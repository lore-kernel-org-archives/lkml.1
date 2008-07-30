Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbYG3TrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbYG3TrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYG3TqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:46:13 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:4535 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611AbYG3TqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:46:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=Mr61HxraWnnsJyPYiLH1igAizRzJ1OQ7pGeMN6P2TRN3lj7JbwdG0wys2gLSdGQLZ/
         nEhE/MsFBppgd1YfVqHagsV+nxZxPGtQFqrkBIVw8XHl06muQoWw9BV9R4r6LStg4z+9
         1M1+mKZ9nm13EkjnpKRMQH8FFR/uVAj+ZRRTk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: gshan <gshan@alcatel-lucent.com>
Subject: Re: PIIX4: DMA timeout issue
Date: Wed, 30 Jul 2008 21:43:37 +0200
User-Agent: KMail/1.9.9
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
References: <488ED837.2060509@alcatel-lucent.com> <200807291713.29580.bzolnier@gmail.com> <488FBC6F.2080800@alcatel-lucent.com>
In-Reply-To: <488FBC6F.2080800@alcatel-lucent.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200807302143.37693.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 July 2008, gshan wrote:

[...]
 
> The IRQ routing issue has been fixed. IRQ routing system
> on my board is somewhat complicated: i8259->mlba (FPGA based
> PCI device)->MV64460(system controller). I forgot to set MV64460
> IRQ pin to level sensitive and edge sensitive was used, which caused
> interrupt lost finally. After changing this to level sensitive, everything
> seems fine. Now, the problem isn't interrupt lost, but suspending DMA
> operations.

Thanks for explaining this.

> > Also is the problem still present in 2.6.26 or 2.6.27-rc1?
> >
> > [ I don't see an information about the kernel version that is
> >   being used in either of threads? ]
> >   
> Sorry, I'm using 2.6.21 kernel.

Would be great to try with some recent one, the issue may have been
fixed already (which is quite likely given a number of bugfixes that
went in recent kernels).

Thanks,
Bart
