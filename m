Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbXLWJuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbXLWJuf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 04:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXLWJu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 04:50:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:17096 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbXLWJuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 04:50:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AYDifLNaBd5zGDV0MHKDBNJZzAqV/YbpNMusvv3L3NOVq61+iAKCpuOCrnv0BXeW9M1SLKClDWw/F+VG8e1/qeKL8JR8NxhbaSL+M8MGqsoOTiM5vOeGRDizTySZl8tsMULl3pIHa6Xyy3WREMq2wF7dIWFKnvrNb6rGINWxlyw=
Message-ID: <d9def9db0712230150h8d16888g9f36d4731ef8b192@mail.gmail.com>
Date: Sun, 23 Dec 2007 10:50:23 +0100
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [GIT PATCH] USB fixes for 2.6.24-rc5
Cc: "Linus Torvalds" <torvalds@osdl.org>, "Andrew Morton" <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <20071223072418.GA8764@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071223072418.GA8764@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

did anyone already take care about:
http://www.mail-archive.com/linux-usb-devel@lists.sourceforge.net/msg55641.html

the fix seems to paper the issue although it happened with other
people too now, so I wonder if there's any progress in that area?

thanks & have a nice Christmas,
Markus

On Dec 23, 2007 8:24 AM, Greg KH <gregkh@suse.de> wrote:
> Here are some USB fixes and new device ids against your 2.6.24-rc6 git
> tree.
>
> Please pull from:
>         master.kernel.org:/pub/scm/linux/kernel/git/gregkh/usb-2.6.git/
>
> The full patches will be sent to the linux-usb mailing list (note the
> address change), if anyone wants to see them.
>
> thanks,
>
> greg k-h
>
> ------------
>
>  drivers/usb/gadget/fsl_usb2_udc.c |    2 +-
>  drivers/usb/serial/cp2101.c       |    1 +
>  drivers/usb/serial/sierra.c       |    2 ++
>  3 files changed, 4 insertions(+), 1 deletions(-)
>
> ---------------
>
> Kevin R Page (1):
>       USB: VID/PID update for sierra
>
> Martin Kusserow (1):
>       USB: New device ID for the CP2101 driver
>
> Peter Korsgaard (1):
>       USB: Unbreak fsl_usb2_udc
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
http://www.couchsurfing.com/people/mrec
