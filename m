Return-Path: <linux-kernel-owner+w=401wt.eu-S1757847AbXEWDq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757847AbXEWDq7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 23:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbXEWDqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 23:46:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.239]:6483 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774AbXEWDqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 23:46:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Dle6IZrE7pdmL9oJyT66NM3e8hNx9pMR+fJ68c5QLvT/JBi5MZtnrlunfkQFd2el3VK2jCVuYByc1TB8pKyL8rImjR0k//tjcQwVxAY+z5wiunQgLDrwS/uZvnquzOrfdTjTaohWnkfmfU2/VDBbL94RRomqwnFeyq9jF6+jfwo=
Message-ID: <3ae72650705222046o352ca76epbd5c36dea7706e70@mail.gmail.com>
Date: Wed, 23 May 2007 05:46:50 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Y Khan" <ykhanportland@yahoo.com>
Subject: Re: class_device_create() and the mode of the device file in /dev.
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <288328.633.qm@web90313.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <288328.633.qm@web90313.mail.mud.yahoo.com>
X-Google-Sender-Auth: 3eefc75c668a8169
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/23/07, Y Khan <ykhanportland@yahoo.com> wrote:
> I am porting a driver from 2.4 to 2.6. I have replaced
> the call devfs_register() with class_create() and
> class_device_create(). Now, udev is automatically
> creating the device file in /dev.

Please use device_create(), class_device_* will go away in the future.

> The device file being created has a default mode of
> 0600. Is it possible to override this default mode
> from inside the kernel. I do not want to do anything
> in the configuration file for udev.
>
> I could modify the attribute of the class and the
> class device but I do not think that they will change
> the default permissions for the /dev device file.
>
> devfs_register() used to take a mode argument.

No, the kernel is not involved in specifying /dev permissions. You
have to add a udev rule to assign a mode that isn't the default.

Thanks,
Kay
