Return-Path: <linux-kernel-owner+w=401wt.eu-S1946643AbXBQKzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946643AbXBQKzU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 05:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946647AbXBQKzU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 05:55:20 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:19599 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946643AbXBQKzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 05:55:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PvMqciJV0AutF/UpWz9b5R1x4Y3Vy/96/xupaghc+UF+6Qsdx1jO3IRchU3PMYiNySoLVUURyJv5kmtMQBPEkk6Wq7BS6mC1r5xJM/9Gwev71Xfb1x/iCCXWZUJLIKqx2ftPspOKszhXVqx9oFYy5qZXvqh/wEOR/SkNmgEdYR0=
Message-ID: <edd3ff190702170255w1c30fa08v96e5b92baacbd701@mail.gmail.com>
Date: Sat, 17 Feb 2007 11:55:17 +0100
From: "=?ISO-8859-1?Q?Daniel_Aragon=E9s?=" <danarag@gmail.com>
To: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
In-Reply-To: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/17/07, Cédric Augonnet <cedric.augonnet@gmail.com> wrote:

> ...
> Hi Daniel,
>
> On 2.6.20-rc6-mm3 and 2.6.20-mm1, i get an OOPS when using the minix 3
> file system. I enclose the dmesg and the .config to that mail.
>
> Here are the steps to reproduce this oops (they involve using qemu to
> run Minix 3)
>  - First create a 2GB image using
>       qemu-img create minix.img 2G
>    (Please note that this seem to be producing an eroneous image)
>  - Then launch Minix inside qemu to make a minix partition on this
> image using mkfs on the corresponding device.
>  - Mount the image on loopback using
>   mount -t minix -o loop minix.img /mnt/qemu/
>  - issue a "df" command on /mnt/qemu
>...

 Well, a glance at your dmesg doesn' show that a minix partition was
recognized. Otherwise it would sow it. So you have not such a
partition within your drives.

You are using an emulator to run minix. You will have the same problem
if you run minix2 or minix3 through an emulator and not from a real
minix2 or minix3 partition.

Regards,

Daniel
