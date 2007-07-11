Return-Path: <linux-kernel-owner+w=401wt.eu-S1759054AbXGKDWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759054AbXGKDWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 23:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbXGKDVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 23:21:51 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:43808 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbXGKDVu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 23:21:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HDE1SzjAmE1fKVhMc5QsUrI+ipx2ssIBcWqdTA4QRpbh94gaoGJvwlGWNh8arjbP9aBP/XGOv+BWoMoqIh5vwytPPkOfhbL/ZjKKq09p2IavQgbPojJI7Q3iIDevR0T6hnh36VXYszuQueCYnpl2ShfAl+VjxhIAkdlN+OJ0MYI=
Message-ID: <f56c1ba00707102021k13a758cbx66cbb6ec8bffac49@mail.gmail.com>
Date: Tue, 10 Jul 2007 23:21:49 -0400
From: "=?ISO-8859-1?Q?C=E9dric_Augonnet?=" <cedric.augonnet@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 6][PATCH 1/1]Export jbd stats through procfs
Cc: cmm@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
In-Reply-To: <20070710193117.a4ef6298.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1183275490.4010.134.camel@localhost.localdomain>
	 <20070710193117.a4ef6298.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/7/10, Andrew Morton <akpm@linux-foundation.org>:

Hi all,

> > +     size = sizeof(struct transaction_stats_s);
> > +     s->stats = kmalloc(size, GFP_KERNEL);
> > +     if (s == NULL) {
> > +             kfree(s);
> > +             return -EIO;
>
> ENOMEM

I'm sorry if i missed some point, but i just don't see the use of such
a kfree here, not sure Andrew meant you should only return ENOMEM
instead, but why issuing those kfree(NULL), instead of just a if (!s)
return ENOMEM ?

Regards,
Cédric
