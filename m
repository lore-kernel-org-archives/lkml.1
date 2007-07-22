Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbXGVFrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbXGVFrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 01:47:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751603AbXGVFrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 01:47:00 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:22332 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXGVFq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 01:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Hn/HT34eVtKGquXw+ZqK+lS73mU78vc2xQny2w52cwxgGI0Mm85pcGYqFQL0IVeO0HxRd/idi6ujoZPlC9ko6p+Oj70VvFFPzTBqlyLpUz/i7VPDCXT2pHrZb62dJMh+zXGTHNDV2LaKcX8FtyNpEMVpwHLy7sCSDt4ehwKWOSw=
Message-ID: <46A2EF75.70700@gmail.com>
Date: Sun, 22 Jul 2007 07:47:33 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michael Haboustak <mike-@cinci.rr.com>, Andreas Gal <gal@uci.edu>,
       Vojtech Pavlik <vojtech@suse.cz>, Greg Kroah-Hartman <greg@kroah.com>,
       linux-input@atrey.karlin.mff.cuni.cz
Subject: Re: [PATCH][hid] Fix a NULL pointer dereference when we fail to allocate
 memory
References: <200707220006.20359.jesper.juhl@gmail.com>
In-Reply-To: <200707220006.20359.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl napsal(a):
>  drivers/hid/usbhid/hid-core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
> index b2baeae..3ff7468 100644
> --- a/drivers/hid/usbhid/hid-core.c
> +++ b/drivers/hid/usbhid/hid-core.c
> @@ -743,7 +743,7 @@ static struct hid_device *usb_hid_configure(struct usb_interface *intf)
>  	hid->quirks = quirks;
>  
>  	if (!(usbhid = kzalloc(sizeof(struct usbhid_device), GFP_KERNEL)))

Out of curiosity, where is this freed?

-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
