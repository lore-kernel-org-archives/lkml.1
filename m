Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbYCJBpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbYCJBpu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 21:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbYCJBpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 21:45:39 -0400
Received: from hs-out-0708.google.com ([64.233.178.247]:61372 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYCJBpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 21:45:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iRF45ZtNLRSC85AEvmqmbtKohSIDlSTza8N0kyCc+MOTUdAIcwnR6Wb5cwIKE+NGkuZ34AOhl0YRJyt+kbNtvLicetMNvE5yMEoC184ay2Ya7l4Il+tyQu9fjnBsZoafQb6gaexXp2xnob0XnGkoTAFjYynW8Mvyn9R7G6XSnXU=
Message-ID: <59fd4ce80803091845g2979c23ayfa1e53ce221ef846@mail.gmail.com>
Date: Mon, 10 Mar 2008 10:45:36 +0900
From: "Jeongdo Son" <sohn9086@gmail.com>
To: "Will Newton" <will.newton@gmail.com>
Subject: Re: [BUG REPORT] smc911x: Auto negotiation NOT supported
Cc: LKML <linux-kernel@vger.kernel.org>, Linux-SH <linux-sh@vger.kernel.org>
In-Reply-To: <87a5b0800803070354x391ff718u3af9664804526da1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <59fd4ce80803062200n203e5cd7o152be120adbdb717@mail.gmail.com>
	 <87a5b0800803070354x391ff718u3af9664804526da1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Will

Thanks for your reply.

On Fri, Mar 7, 2008 at 8:54 PM, Will Newton <will.newton@gmail.com> wrote:
>  Are you getting interrupts from the chip? Sounds like it could be you
>  have missed and interrupt somewhere - check where your interrupt
>  polarities and where you are acking/clearing them down.
>

I think there's no problem with getting interrupts.
Because the driver works well while eth0 is configured for DHCP mode.
Only static IP allocation occurs the problem.

Here is the /proc/interrupts.
(The interrupt for eth0 is recognized as IRQ 9)
~ $ cat /proc/interrupts
           CPU0
  3:         46  sh7780-irl3210-level     rtc-62423a period
  6:         67  sh7780-irl3210-level     r8a66597_hcd:usb1
  9:         96  sh7780-irl3210-level     eth0
 12:          0  sh7780-irl3210-level     fb0
 13:          0  sh7780-irl3210-level     fb0
 28:      11366          sh7780-level     periodic timer
 38:          0          sh7780-level     DMAC Address Error
 40:          0          sh7780-level     SCI Receive Error
 41:         62          sh7780-level     SCI Receive Data Full
 42:          0          sh7780-level     SCI Break
 43:       1901          sh7780-level     SCI Transmit Data Empty
 68:          1          sh7780-level     yenta
Err:          0

Regards,
Jeongdo Son
