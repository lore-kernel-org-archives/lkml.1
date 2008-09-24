Return-Path: <linux-kernel-owner+w=401wt.eu-S1753971AbYIXDfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971AbYIXDfd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:35:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751661AbYIXDfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:35:23 -0400
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:43928 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751128AbYIXDfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:35:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wwM2CTkerpyIfObNASOK9oduBBoARWJFyfqxj0nzMJplAZ6GJ3qvZJG+9uXDkF5yuBmR9fLm8MqHTwiiSx53wCix8smGwH89I8ocPJFLqvsJsx2cPNYHnRFmOXrRQPjvfP6xJm6JkORSXz9MMEfhVf3Dn2V8EP2KEKR0OG4G63c=  ;
X-YMail-OSG: oC8N4L0VM1m846oMMq.m0Z015LvxrC9lWlY2IfyF.xV0WATO4zvD2zFkClIgn_aYiWPhMbBw5VEWdmnyGGN1v4JQm82rbOLkxJ7Yr.vm745xMWYjaKuG3xMAy_ZH5ilrUoURuY7BIH6b3IkdQKD3CQzO
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 3/4] USB: Protect hcd.h from multiple inclusions
Date: Tue, 23 Sep 2008 20:35:18 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>,
       Kumar Gala <galak@kernel.crashing.org>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>, linuxppc-dev@ozlabs.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080924000255.GA28054@oksana.dev.rtsoft.ru> <20080924000340.GC29733@oksana.dev.rtsoft.ru>
In-Reply-To: <20080924000340.GC29733@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809232035.19684.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2008, Anton Vorontsov wrote:
> This will let us use this header in other header files.
> Will be needed for the FHCI USB Host driver.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>

This seems innocuous.  I'm content with Greg merging it into
his tree for 2.6.28-rc0 merge ...

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
>  drivers/usb/core/hcd.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.h b/drivers/usb/core/hcd.h
> index e710ce0..66b64d7 100644
> --- a/drivers/usb/core/hcd.h
> +++ b/drivers/usb/core/hcd.h
> @@ -16,6 +16,8 @@
>   * Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#ifndef __USB_CORE_HCD_H
> +#define __USB_CORE_HCD_H
>  
>  #ifdef __KERNEL__
>  
> @@ -483,3 +485,5 @@ static inline void usbmon_urb_complete(struct usb_bus *bus, struct urb *urb,
>  extern struct rw_semaphore ehci_cf_port_reset_rwsem;
>  
>  #endif /* __KERNEL__ */
> +
> +#endif /* __USB_CORE_HCD_H */
> -- 
> 1.5.6.3
> 
> 


