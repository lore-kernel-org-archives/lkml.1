Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbXDBHHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbXDBHHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 03:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbXDBHHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 03:07:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:10057 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325AbXDBHHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 03:07:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=IIVj1Uj9Ub0c6Cna5Spi0kjQOuNxiF5fnE/sz5OcSMgqAy47a1Ml/NHwcN6nIhvl4/T7CagEW/b1o91pFlL33E3VqYXI+BE1xXVF48ob+Ff5gQ9WwV8DkFVplKM/hwDZ0uHuGBcrTH+iDyoFvC5zoeF9KCHarg8u4FVfKc9aIQE=
Message-ID: <84144f020704020007x879f781x45f395298d92cbe@mail.gmail.com>
Date: Mon, 2 Apr 2007 10:07:31 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Cc: "Jens Axboe" <jens.axboe@oracle.com>, "Al Viro" <viro@ftp.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <4610481D.8000102@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>
	 <460EA727.8070306@gmail.com>
	 <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
	 <4610481D.8000102@gmail.com>
X-Google-Sender-Auth: 175c6c105e891a67
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rene,

On 4/2/07, Rene Herman <rene.herman@gmail.com> wrote:
> root@5va2:~# dd if=/dev/mcdx0 of=/dev/null bs=2048
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000221955 seconds, 0.0 kB/s
> root@5va2:~#
>
> This I know isn't:
>
> root@5va2:~# readcd dev=/dev/mcdx0 f=/dev/null
> Segmentation fault
> root@5va2:~#
>
> (leaves a "note: readcd[1174] exited with preempt_count 1" in the log)
>
> and after a "mount -t iso9660 /dev/mcdx0 /mnt/cdrom",  a:
>
> root@5va2:~# tar cv /mnt/cdrom >/dev/null
>
> has upto now done all of:

[snip]

Try with CONFIG_PREEMPT_NONE as suggested by Jens. Can we see strace
for the dd, readcd, and tar runs, please?
