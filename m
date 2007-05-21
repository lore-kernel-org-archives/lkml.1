Return-Path: <linux-kernel-owner+w=401wt.eu-S1763083AbXEUPJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763083AbXEUPJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757983AbXEUPJA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:09:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:47800 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957AbXEUPI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:08:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nYkGV0T2hb4pgPVGZP6munClc5vDn3QelL+Zf7jVS+rj8LxjL3NFpghi8sZBEFJb17bBRjJWQOVcSeUWtm5oKwQdOSob0EZGLqoOOPuJxVAKWeJ5VmXNoCfCLpubO9xEBf3dyCTmy5SklbAdz1wUiOUgH7ZhJAg1TzkzfUTIPUo=
Message-ID: <6bffcb0e0705210808j1acc8f0chd65c4b6168c36078@mail.gmail.com>
Date: Mon, 21 May 2007 17:08:52 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Soeren Sonnenburg" <kernel@nn7.de>
Subject: Re: regression 2.6.22-rc2 suspend to ram broken ( usb_hcd_pci_suspend+0x0/0x170() returns -16 )
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>,
       linux-usb-devel <linux-usb-devel@lists.sourceforge.net>
In-Reply-To: <1179736691.4980.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1179736691.4980.6.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Soeren,

On 21/05/07, Soeren Sonnenburg <kernel@nn7.de> wrote:
> I suddenly can no longer s2ram with 2.6.22-rc2, as this seems caused by
> usb_hcd_pci_suspend I am CC'ing linux usb-devel.

I think, that it's a known bug
http://bugzilla.kernel.org/show_bug.cgi?id=8498

Please try this patch
http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/usb-make-the-autosuspend-workqueue-thread-freezable.patch

>
> I am attaching a dmesg and lspci.
>
> Soeren
> --
> Sometimes, there's a moment as you're waking, when you become aware of
> the real world around you, but you're still dreaming.
>
>

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
