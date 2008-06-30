Return-Path: <linux-kernel-owner+w=401wt.eu-S1759614AbYF3OWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759614AbYF3OWe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYF3OWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:22:24 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:58964 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYF3OWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=cVNQwyOh+ndtWkEC+dg1x4XnrD/JgxfLpDbbkBdcqhYSM6Z2+hIzw5T1lCNUQdpTp/
         zFGmAOk3zggU+CHR2QCRNEFIO930HM82BRyTU6KNJC5N9Wbkvs/nKnEoAUO+DvOA61Nz
         0MzcX6ye6YKcHtcnNkEmWkiYQomCb+dnRRgWo=
Message-ID: <38b2ab8a0806300722t2029314aq2145d400894f9444@mail.gmail.com>
Date: Mon, 30 Jun 2008 16:22:23 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: usb_get_status(): what a weird implementation !
Cc: "David Brownell" <david-b@pacbell.net>, linux-usb@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806301611.42464.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806261011.00287.oliver@neukum.org>
	 <200806301551.42252.oliver@neukum.org>
	 <38b2ab8a0806300703j7c0f0567w4cf1730fbe375c00@mail.gmail.com>
	 <200806301611.42464.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 4:11 PM, Oliver Neukum <oliver@neukum.org> wrote:
>
> Well, we have:
> asm-mips/mach-ip32/kmalloc.h:#define ARCH_KMALLOC_MINALIGN      128
> That's 256 bytes, that is 1/16 of the stack.

yep but I wouldn't call such beast an embedded system ;)

And on this system stack size is 8 KiB.

But I agree a plain stack allocation as I showed is not usable.

-- 
Francis
