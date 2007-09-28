Return-Path: <linux-kernel-owner+w=401wt.eu-S1753077AbXI1KhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbXI1KhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 06:37:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbXI1Kgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 06:36:53 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:37671 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXI1Kgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 06:36:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=rAN3xO5ngQH3LjVXubfzrMuM7gQ8XRIbDLiaL8NSLXvIj0K9WfB+GPp8xU1ulTj2bS137PGB3QGgAZNA0bT7EKpbuXhWf6SGJMnerBaYdFHsr9RNsw8ZdI2smPpqRm2wtQI/ScbWeXnHaa8Eg1+DxF7vZlAdNZds6JBPapEIv/4=
Message-ID: <92cbf19b0709280336r1af60b3cq945cdd03366b8102@mail.gmail.com>
Date: Fri, 28 Sep 2007 03:36:51 -0700
From: "Chakri n" <chakriin5@gmail.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: A unresponsive file system can hang all I/O in the system on linux-2.6.23-rc6 (dirty_thresh problem?)
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
In-Reply-To: <1190971419.31636.38.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	 <20070927235034.ae7bd73d.akpm@linux-foundation.org>
	 <1190962752.31636.15.camel@twins>
	 <92cbf19b0709280127yba48b60wfe58e532944894ca@mail.gmail.com>
	 <1190968800.31636.26.camel@twins>
	 <92cbf19b0709280201o3778f945mf1d8d61cbb3d0558@mail.gmail.com>
	 <1190970729.31636.29.camel@twins>
	 <92cbf19b0709280220o7cdd4b1cua37a8776af68ac25@mail.gmail.com>
	 <1190971419.31636.38.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's works on .23-rc8-mm2 with out any problems.

"dd" process does not hang any more.

Thanks for all the help.

Cheers
--Chakri


On 9/28/07, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>  [ and one copy for the list too ]
>
> On Fri, 2007-09-28 at 02:20 -0700, Chakri n wrote:
> > It's 2.6.23-rc6.
>
> Could you try .23-rc8-mm2. It includes the per bdi stuff.
>
>
