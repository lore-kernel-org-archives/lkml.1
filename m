Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbXKUHgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbXKUHgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 02:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755913AbXKUHgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 02:36:36 -0500
Received: from wr-out-0506.google.com ([64.233.184.238]:42726 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbXKUHgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 02:36:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nZ82ZnISFg+y0pf/k2/DKNHNG7JNm8c3cfHSxzhs4L7oWTyzrQGtjgV66RNFxuvLtss8DeE9xlNyDuR48Yqw4+Co8uB9ijGjExk9vWrZtxAhDT7qyQN9R5kq2bao+2vs1t0r6PxRR+han7cMwzrPb3W5S21fxlwih9bqLJ039hA=
Message-ID: <21d7e9970711202336m2e4f998fgc13df8a3a74101e4@mail.gmail.com>
Date: Wed, 21 Nov 2007 17:36:33 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Prospects of DRM TTM making it into 2.6.24?
Cc: "Dave Airlie" <airlied@linux.ie>, linux-kernel@vger.kernel.org
In-Reply-To: <20071119141554.649b590e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.DEB.0.82.0711192151010.1284@skynet.skynet.ie>
	 <20071119141554.649b590e.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I also have a few AGP changes I need to line up to support the chipset
> > flushing work I've done to support TTM properly..
> >
>
> Did anything happen with that null-pointer deref I was hitting?
>

I've rebased the patches in my tree along with a chunk I missed which
should make your patch unnecessary.

Do you pull my agp-mm tree into -mm?

ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6 agp-mm
if not..

Dave.
