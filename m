Return-Path: <linux-kernel-owner+w=401wt.eu-S966269AbXEVQka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966269AbXEVQka (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757856AbXEVQkV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:40:21 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:45423 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbXEVQkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:40:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mJgC4doY40APOn8p8UeQekozcn1zL7pc3vGmpe5pIZJEyqPxLj+yZrbP0bTGNaBwJZFHOnpuUo6biKoPNDHGLSjX1o4CLZpFm+MzxC0wCvWEoWZHwVQW6vDKMc/LaSBnBj5m+/ca9P9LeSHePeAvpKq5qZUKQaHEomluKYOlYhE=
Message-ID: <6bffcb0e0705220940p22275f1dk46942db747c0a2e0@mail.gmail.com>
Date: Tue, 22 May 2007 18:40:17 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Luigi Genoni" <l.genoni@oltrelinux.com>
Subject: Re: BUG: at mm/slab.c:777 __find_general_cachep()
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <200705221835.11559.l.genoni@oltrelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705221835.11559.l.genoni@oltrelinux.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luigi,

On 22/05/07, Luigi Genoni <l.genoni@oltrelinux.com> wrote:
> While doing eavy I/O on a RAID1 logical volume with reiserfs with kernel
> 2.6.22-rc2 on Athlon64 3800+ X2, i got:
>
> BUG: at mm/slab.c:777 __find_general_cachep()

Here is a patch
http://lkml.org/lkml/diff/2007/5/18/19/1

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
