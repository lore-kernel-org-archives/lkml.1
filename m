Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYF3OEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYF3OEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 10:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbYF3ODz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 10:03:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:47058 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbYF3ODy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 10:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Wf5t6C28Of0kk2kngEF9IcFdh9tBB3OwMzrZYVJFSVuY9903UbAXOTTo7TdDQiBGn4
         jV6bLyhqiEhyef4Vyrr8nvnx1H9ewfVGrIejagjsIgE4dzJv/ydnk+rfRfRWeXUGnqxQ
         sBQkaISYZ38acKn1eXW7qT9GfNg5tEVf524c0=
Message-ID: <38b2ab8a0806300703j7c0f0567w4cf1730fbe375c00@mail.gmail.com>
Date: Mon, 30 Jun 2008 16:03:52 +0200
From: "Francis Moreau" <francis.moro@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: usb_get_status(): what a weird implementation !
Cc: "David Brownell" <david-b@pacbell.net>, linux-usb@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806301551.42252.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806261011.00287.oliver@neukum.org>
	 <200806301346.11267.oliver@neukum.org>
	 <38b2ab8a0806300541q756e9b6fl445a5ee69d403ce7@mail.gmail.com>
	 <200806301551.42252.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 3:51 PM, Oliver Neukum <oliver@neukum.org> wrote:
>
> If your buffer is smaller than CACHE_LINE_SIZE it should work.
> However, this needs input from people who understand DMA in and out.

yeah, that's the reason why it's a hack.

Maybe adding a new helper in  the dma API would be better...

> But how large is 2 * CACHE_LINE_SIZE compared to the kernel stack?

CACHE_LINE_SIZE = 32 bytes is common for embedded systems I guess.
For big system, I dunno.

Kernel stack size is usually  4KiB.

-- 
Francis
