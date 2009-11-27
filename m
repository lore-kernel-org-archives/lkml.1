Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbZK0EcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbZK0EcS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 23:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753285AbZK0EcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 23:32:17 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:44957 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZK0EcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 23:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=giX5LXBqjWdGfL1l5JcIfkPiT2ZElauVmmbzKxm9qkaev5+I4Y5zIPP4z6xBts3BUa
         2iW7wfRQfCMLcj3iHty8bdbbmq9Lp7HeOLQeJU6t81YPGA6bZXo5L34yzlytEn5ujHxg
         YNRKFLJNnvfnmk6tqZvjqrceeybxbwqdnJsbs=
MIME-Version: 1.0
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901EE5BE1@mi8nycmail19.Mi8.com>
References: <BD79186B4FD85F4B8E60E381CAEE190901EE5BE1@mi8nycmail19.Mi8.com>
Date: Fri, 27 Nov 2009 13:32:23 +0900
Message-ID: <57afda040911262032u5e398303p2d704214ce7cf43b@mail.gmail.com>
Subject: Re: drivers/block/mg_disk.c: use resource_size()
From: unsik Kim <donari75@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use resource_size() for ioremap.
>
> The ioremap appears to be passing the incorrect size for the platform
> resource.  Unfortunately, I can't locate a user in mainline to verify
> this.  Using resource_size should be the correct fix.

The patch is definitely right. I tested it in ARM platform.
Thank you for your patch.

---
Regards,
unsik Kim <donari75@gmail.com>
