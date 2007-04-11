Return-Path: <linux-kernel-owner+w=401wt.eu-S1750837AbXDKHTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750837AbXDKHTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 03:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750888AbXDKHTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 03:19:44 -0400
Received: from smtp.osdl.org ([65.172.181.24]:34787 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbXDKHTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 03:19:43 -0400
Date: Wed, 11 Apr 2007 00:19:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [-mm3 PATCH] (Retry) Check the return value of kobject_add and
 etc.
Message-Id: <20070411001929.5162cf41.akpm@linux-foundation.org>
In-Reply-To: <20070411064525.GC4343@localhost.localdomain>
References: <20070405045410.GA4692@localhost.localdomain>
	<20070405111142.4723035f@gondolin.boeblingen.de.ibm.com>
	<20070405144409.GA5294@localhost.localdomain>
	<20070405170514.481b765f@gondolin.boeblingen.de.ibm.com>
	<20070405152732.GA5569@localhost.localdomain>
	<20070405180016.5099e0cd@gondolin.boeblingen.de.ibm.com>
	<20070406025343.GA2407@localhost.localdomain>
	<20070410143106.03d62e7c@gondolin.boeblingen.de.ibm.com>
	<20070410140829.GA3382@localhost.localdomain>
	<20070410151815.906ef9b4.akpm@linux-foundation.org>
	<20070411064525.GC4343@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007 14:45:25 +0800 WANG Cong <xiyou.wangcong@gmail.com> wrote:

> >-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%sp%d",disk->kobj.name,part);
> >+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%sp%d",
> >+				disk->kobj.name, part);
>                                                ^^^
> Andrew, it seems that you left an additional whitespace in the above line (marked as ^^^).
> 
> > 	else
> >-		snprintf(p->kobj.name,KOBJ_NAME_LEN,"%s%d",disk->kobj.name,part);
> >+		snprintf(p->kobj.name, KOBJ_NAME_LEN, "%s%d",
> >+				disk->kobj.name, part);
>                                                ^^^
> Also here. ;-p

Those are known as "fixes" ;)

One shouldn't mix whitespace fixes with functional changes really, but I
can't help myself.
