Return-Path: <linux-kernel-owner+w=401wt.eu-S933196AbXBRKm7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933196AbXBRKm7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 05:42:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933195AbXBRKm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 05:42:59 -0500
Received: from nf-out-0910.google.com ([64.233.182.187]:28216 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbXBRKm6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 05:42:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mMxwEFjtCEEsOVB9PX34JJTxtrKiW9bcdk+gYAom6xYx7F/0DLXttkAqX1VLnpdsaSy/6rxcnxr0ojnJlOp0DTuyrTOMNo3ZLFNbpqts8Qvbj5qPUIzDKEYTxhp6cZggbGJM9FG+aoxdJVflH1vNspZC3yPG8GvcpKY0waYxLLk=
Message-ID: <f56c1ba00702180242l68ea66eds6de8ca7b78436eb9@mail.gmail.com>
Date: Sun, 18 Feb 2007 11:42:54 +0100
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Bill Davidsen" <davidsen@tmr.com>
Subject: Re: 2.6.20-mm1 - Oops using Minix 3 file system
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Daniel Aragones" <danarag@gmail.com>, linux-kernel@vger.kernel.org,
       Cedric.augonnet@ens-lyon.org
In-Reply-To: <f56c1ba00702171201y1e4ea025t510e4d4e7dbcf3b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <f56c1ba00702161500x775fe04bl91889b5819cf9ddc@mail.gmail.com>
	 <45D75A1F.8060504@tmr.com>
	 <f56c1ba00702171201y1e4ea025t510e4d4e7dbcf3b2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/2/17, Cédric Augonnet <cedric.augonnet@gmail.com>:
> 2007/2/17, Bill Davidsen <davidsen@tmr.com>:
> > Cédric Augonnet wrote:
>
> That is my all point actually, i am not telling i have a valid
> partition. I'm just describing the fact that the minix fs driver is
> making too many assumptions on the partition it is given. For sure
> there must be something nasty about this image, as you told this is
> the duty of the kernel not to mount such a partition if it is not a
> partition. Here I was only giving an example of the way we could trick
> the driver. This is as important as having the driver working
> correctly on valid partitions i suppose.


Eventually the problem got solved  by Andries Bouwer :
http://marc.theaimsgroup.com/?l=linux-mm-commits&m=117176125510900&w=2

Now i can issue a df command on this partition or whatever it may be,
and i obtain a consistent result wiythout any oops.

Regards,
Cédric
