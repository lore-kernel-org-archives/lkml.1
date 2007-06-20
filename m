Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbXFTKkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbXFTKkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 06:40:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757934AbXFTKkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 06:40:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59992 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbXFTKkY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 06:40:24 -0400
From: Hans-Peter Jansen <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] XFS:  Replace remaining memclear_highpage_flush() with zero_user_page().
Date: Wed, 20 Jun 2007 12:40:10 +0200
User-Agent: KMail/1.9.5
Cc: Christoph Hellwig <hch@infradead.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Andrew Morton <akpm@osdl.org>, xfs-masters@oss.sgi.com
References: <Pine.LNX.4.64.0706181154090.26616@localhost.localdomain> <20070618184343.GB17479@infradead.org>
In-Reply-To: <20070618184343.GB17479@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201240.11476.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/YcbATYNRwOSMbe9fsyRRgxNRh76V/79jxf5F
 mMF8/vDMNbB74qPGmfsjgyOK1PaJ4G6mxpe4n456pCeGdk6H8C
 Vmh03NeFrGRIf6Usu3Mfg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 18. Juni 2007 20:43 schrieb Christoph Hellwig:
> On Mon, Jun 18, 2007 at 11:59:30AM -0400, Robert P. J. Day wrote:
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

FYI, this patch got attributed to Christoph in Linus' tree with commit 
700716c8468d95ec6d03566a4e4fb576c3223cbc..

Cheers,
  hp


> > ---
> >
> >   this appears to be the final occurrence of that deprecated call in
> > the entire tree which suggests that, if you're not concerned about
> > out-of-tree modules, that definition could also be removed from
> > include/linux/highmem.h:
> >
> > static inline void __deprecated memclear_highpage_flush(struct page
> > *page, unsigned int offset, unsigned int size) {
> >         zero_user_page(page, offset, size, KM_USER0);
> > }
>
> Andrew, please send this and the memclear_highpage_flush removal to Linus
> for 2.6.22-rc.  The warning is really highly annoying and utterly
> pointless. -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
