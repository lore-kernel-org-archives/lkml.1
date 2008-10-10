Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYJJGfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYJJGfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 02:35:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbYJJGe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 02:34:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50099 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbYJJGe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 02:34:58 -0400
Subject: RE: [ANNOUNCE] [PATCH] [MTD] Flex-OneNAND MTD Driver available.
From: David Woodhouse <dwmw2@infradead.org>
To: apgmoorthy <moorthy.apg@samsung.com>
Cc: "'Kyungmin Park'" <kmpark@infradead.org>, linux-mtd@lists.infradead.org,
       "'lkml'" <linux-kernel@vger.kernel.org>, dedekind@infradead.org
In-Reply-To: <000b01c92215$ae62d4e0$3dd66c6b@sisodomain.com>
References: <19198934.52871221827459790.JavaMail.weblogic@epml16>
	 <9c9fda240809220011w49c0875q804f836550ff3476@mail.gmail.com>
	 <000001c91e42$1aa86c50$3dd66c6b@sisodomain.com>
	 <9c9fda240809251731y48272a63j988e0001dc50d78@mail.gmail.com>
	 <1222404711.5012.5.camel@sauron>
	 <A09E9029F2344F78959A3E36179C468E@sisodomain.com>
	 <1222417176.5012.17.camel@sauron>
	 <000b01c92215$ae62d4e0$3dd66c6b@sisodomain.com>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 07:34:53 +0100
Message-Id: <1223620493.28324.90.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-09-29 at 14:58 +0530, apgmoorthy wrote:
>    Please do comment on this patch. 
> 
>    "Not to expose whole OOB" suggestion by Kyungmin should be fine ,
> but looking for your suggestion.

I'm working on a revamp of the MTD core which would start exposing
attributes by sysfs, which would mean a lot of the ioctl problems go
away. I suspect it would be OK simply not to export the whole OOB, until
that's done.

I posted other code which can export things in sysfs already -- perhaps
we don't need to wait until the core rewrite is done?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

