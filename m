Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab0BIPC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 10:02:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0BIPCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 10:02:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] Fix for hugetlb-add-map_hugetlb-for-mmaping-pseudo-anonymous-huge-page-regions.patch in -mm
Date: Tue, 9 Feb 2010 16:01:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Eric B Munson <ebmunson@us.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       linux-man@vger.kernel.org, mtk.manpages@gmail.com
References: <1252487811-9205-1-git-send-email-ebmunson@us.ibm.com> <Pine.LNX.4.64.0909152146470.25625@sister.anvils> <20100208145605.5eea30b5.randy.dunlap@oracle.com>
In-Reply-To: <20100208145605.5eea30b5.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002091601.28463.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/p0EsINOjgemqeGA+vWEcrx8r3LE4PLzH7g0u
 sh6/ygI2dQN9YcOwYZ6Ep/wF/URLwbu3M0Y8IBb9I5vXVSxGP3
 RcjnFPbFuhxjgyWOCjuKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 February 2010, Randy Dunlap wrote:
> On Tue, 15 Sep 2009 21:53:12 +0100 (BST) Hugh Dickins wrote:
> 
> > On Tue, 15 Sep 2009, Eric B Munson wrote:
> > > Resending because this seems to have fallen between the cracks.
> > 
> > Yes, indeed.  I think it isn't quite what Arnd was suggesting, but I
> > agree with you that we might as well go for 0x080000 (so that even Alpha
> > can be just a cut-and-paste job from asm-generic), and right now it's
> > more important to finalize the number than what file it appears in.
> > 
> > Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> 
> so what happened with this patch ??

In a later revision, we agreed to put the definition into
asm-generic/mman.h, where it was merged in 2.6.32.

	Arnd
