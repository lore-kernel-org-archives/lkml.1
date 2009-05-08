Return-Path: <linux-kernel-owner+w=401wt.eu-S1755981AbZEHPXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981AbZEHPXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZEHPXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:23:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:4755 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755781AbZEHPXF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:23:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dLs4NsrzWzMA0jbDOmFus3lnQ/J8/5ho9KHFtYkgPA6X2aSy7CVK62uzzNEL6+naC6
         dZ5k6kYhYFYGO9wn4kTk2T2Hy+3Cz9mW0SnFHUrMErQ6c3POyKNZZMcSrPrUqppdD4Co
         zmb3e9WZcWyGLd6awO9CyGPd7ZSpuojroXQMM=
MIME-Version: 1.0
In-Reply-To: <20090506222439.GB22327@kroah.com>
References: <20090506222439.GB22327@kroah.com>
Date: Fri, 8 May 2009 23:22:43 +0800
Message-ID: <a276da400905080822u61f18893x3bd044037abee004@mail.gmail.com>
Subject: Re: usbutils 0.82 release
From: Xiaofan Chen <xiaofanc@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 7, 2009 at 6:24 AM, Greg KH <greg@kroah.com> wrote:
> Here's the 0.82 release of usbutils.
>
> Many bugs with autoconf were resolved to hopefully make it easier for
> distros to find where the usb.ids file is dynamically.  Wireless USB
> device support was added, as well as other bugfixes.  The full shortlog
> is below.

By the way, the issue with "lsusb -t" has not been solved.

mcuee@ubuntu904:~/Desktop/build/usbutils/usbutils-0.82$ lsusb -t
2-2:1.0: No such file or directory
2-8:1.0: No such file or directory
/:  Bus 02.Port 1: Dev 1, Class=root_hub, Driver=ohci_hcd/8p, 12M
    |__ Port 1: Dev 2, If 0, Class=stor., Driver=usb-storage, 12M
    |__ Port 2: Dev 3, If 0, Class=HID, Driver=, 12M
    |__ Port 4: Dev 4, If 0, Class=HID, Driver=usbhid, 1.5M
    |__ Port 5: Dev 5, If 0, Class=vend., Driver=ftdi_sio, 12M
    |__ Port 7: Dev 6, If 0, Class=HID, Driver=usbhid, 12M
    |__ Port 8: Dev 7, If 0, Class=vend., Driver=, 12M
/:  Bus 01.Port 1: Dev 1, Class=root_hub, Driver=ehci_hcd/8p, 480M



-- 
Xiaofan http://mcuee.blogspot.com
