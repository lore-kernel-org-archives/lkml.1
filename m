Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbZEVLqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbZEVLqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZEVLq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:46:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53585 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228AbZEVLq1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:46:27 -0400
X-IronPort-AV: E=Sophos;i="4.41,233,1241409600"; 
   d="scan'208";a="4394183"
Subject: Re: [PATCH] swiotlb: make swiotlb phys<->bus translations
	architecture-specific
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "jeremy@goop.org" <jeremy@goop.org>,
       "beckyb@kernel.crashing.org" <beckyb@kernel.crashing.org>,
       "okir@suse.de" <okir@suse.de>, "mingo@elte.hu" <mingo@elte.hu>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "xendevel@lists.xensource.com" <xendevel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090522200437P.fujita.tomonori@lab.ntt.co.jp>
References: <1242906335.22654.188.camel@zakaz.uk.xensource.com>
	 <1242922528-5982-7-git-send-email-ian.campbell@citrix.com>
	 <20090522200437P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 22 May 2009 12:46:26 +0100
Message-ID: <1242992786.22654.281.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 07:13 -0400, FUJITA Tomonori wrote:
> > +static inline phys_addr_t swiotlb_bus_to_phys(struct device *hwdev,
> > +                                           dma_addr_t baddr)
> > +{
> > +     return baddr;
> > +}
> > +
> > +
> 
> As I wrote in another mail, adding swiotlb specific code in
> dma-mapping.h is wrong.

They aren't really swiotlb specific, I just foolishly carried over the
old name, really I think they should be called just bus_to_phys and
phys_to_bus or something.

Ian.

