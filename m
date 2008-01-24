Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYAXKFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYAXKFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 05:05:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYAXKFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 05:05:21 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:60711 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYAXKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 05:05:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LPfutfZuQOkNNIpkL2CmCRDY5Z0C5hNX3TZDTKjSoMeG5nsrmZ7hn1k0aAFxbhrN04jMC02NYwZiqYiEmnN+BBOSzX9B33pt0B6M0CYf1q0gYfwF7ciubYICmNSHATN/XRuONaCWHbaLvQMEVZUpAXwqP7lN5UyQ+UiNs7ljUXw=
Message-ID: <6c4c86470801240205u5361e090jc057270b03b5ebe7@mail.gmail.com>
Date: Thu, 24 Jan 2008 11:05:18 +0100
From: "Wilco Beekhuizen" <wilcobeekhuizen@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH] Missing usb_find_device symbol from usb.c
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080124013720.GA21978@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6c4c86470801221118x530ee074qedb1da5eac1ca473@mail.gmail.com>
	 <20080124013720.GA21978@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/24, Greg KH <greg@kroah.com>:
> On Tue, Jan 22, 2008 at 08:18:32PM +0100, Wilco Beekhuizen wrote:
> > 2.6.24-rc8 (possibly lower rc's too) has usb_find_device removed from
> > usb.c. This causes problems when compiling modules that need
> > usb_find_device.
> > This patch puts the symbol back in place. Unless someone has a good
> > reason not to include usb_find_device?
>
> I don't see any users in the kernel tree of this function that can be
> built as a module.
>
> Do you know of any external modules that need it?  Any pointers to the
> code anywhere?
>
> thanks,
>
> greg k-h
>

Well I need it for my iriver mp3 player. This driver currently resides
here: http://www.init0.nl/iriver.php

Most code is pretty ancient, I just manage it so it compiles with
recent kernels. Is there somehting exported that is similar to
usb_find_device?

Wilco
