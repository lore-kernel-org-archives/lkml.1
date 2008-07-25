Return-Path: <linux-kernel-owner+w=401wt.eu-S1757032AbYGYA5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032AbYGYA5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 20:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753328AbYGYA51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 20:57:27 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:36381 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753823AbYGYA50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 20:57:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Is0TXrNMql+Uj8nl8dCXlpC1eEu1fmiG5ELZt6CUZPFPh9lLEvWpDVLXTGJyvtgdBh8E0de9X9tIQMzUrbWbDecY1BJyUJZR75I+A4KFfLfs2+kmg8StLNFMNXtzxx8Uw4bejJ+twamtLCvCCII9Sdp1Al5/tuo9XlzpsK+hbMQ=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] usb: move ehci reg def
Date: Thu, 24 Jul 2008 17:57:22 -0700
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
References: <200807231252.20371.yhlu.kernel@gmail.com> <200807231739.39620.yhlu.kernel@gmail.com> <200807241727.57692.yhlu.kernel@gmail.com>
In-Reply-To: <200807241727.57692.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241757.23441.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2008, Yinghai Lu wrote:
> 
> prepare x86: usb debug port early console
> 
> move ehci struct def to linux/usrb/ehci_def.h from host/ehci.h
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

so long as the minor issue below is fixed:


>  
> 	...
> +#include <linux/usb/ehci_def.h>
>  
>  /*-------------------------------------------------------------------------*/
>  
> +

Only one blank line needed please.  ;)


>  #define	QTD_NEXT(ehci, dma)	cpu_to_hc32(ehci, (u32)dma)
>  
>  /*

