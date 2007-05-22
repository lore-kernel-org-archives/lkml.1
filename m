Return-Path: <linux-kernel-owner+w=401wt.eu-S966475AbXEVQrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966475AbXEVQrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 12:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbXEVQqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 12:46:50 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:21912 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbXEVQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 12:46:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tjP3KeY9jih9xtipBr506Zg4NFg8L7/FidXDBVVZvHuY4jZCtgpHdv6kMZjxn4bW5VTDljOfo4vlyLSt3kSyA9mb0qtPdasuGTlnMY9iLLZd6Rqj5JFoKuZiw22e58/jFJMivA6HE+P74fupFyw4+FCYjNEFP7QfolYrKAc4EV0=
Message-ID: <a781481a0705220946v1c94e0a0r897e6811abcd23c4@mail.gmail.com>
Date: Tue, 22 May 2007 22:16:46 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: BUG: at mm/slab.c:777 __find_general_cachep()
Cc: "Luigi Genoni" <l.genoni@oltrelinux.com>, linux-kernel@vger.kernel.org
In-Reply-To: <6bffcb0e0705220940p22275f1dk46942db747c0a2e0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705221835.11559.l.genoni@oltrelinux.com>
	 <6bffcb0e0705220940p22275f1dk46942db747c0a2e0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/07, Michal Piotrowski <michal.k.k.piotrowski@gmail.com> wrote:
> Hi Luigi,
>
> On 22/05/07, Luigi Genoni <l.genoni@oltrelinux.com> wrote:
> > While doing eavy I/O on a RAID1 logical volume with reiserfs with kernel
> > 2.6.22-rc2 on Athlon64 3800+ X2, i got:
> >
> > BUG: at mm/slab.c:777 __find_general_cachep()
>
> Here is a patch
> http://lkml.org/lkml/diff/2007/5/18/19/1

Eek, no ... he wants this one: http://lkml.org/lkml/diff/2007/5/16/513/1
