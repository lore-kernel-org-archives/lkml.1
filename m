Return-Path: <linux-kernel-owner+w=401wt.eu-S1764229AbYHFLW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764229AbYHFLW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 07:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758336AbYHFLWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 07:22:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:58019 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179AbYHFLWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 07:22:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,314,1215414000"; 
   d="scan'208";a="426536886"
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V3.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Pavel Machek <pavel@suse.cz>, bunk@kernel.org, dwmw2@infradead.org,
       davem@davemloft.net, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <20080806111724.GA32129@gondor.apana.org.au>
References: <1218000211.4231.23.camel@localhost.localdomain>
	 <20080806094226.GA23685@atrey.karlin.mff.cuni.cz>
	 <1218020727.29030.16.camel@localhost.localdomain>
	 <20080806111724.GA32129@gondor.apana.org.au>
Content-Type: text/plain
Date: Wed, 06 Aug 2008 07:20:14 -0400
Message-Id: <1218021614.29030.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-08-06 at 19:17 +0800, Herbert Xu wrote:
> On Wed, Aug 06, 2008 at 07:05:27AM -0400, Austin Zhang wrote:
> >
> > > > +		return -1;
> > > 
> > > That's supposed to be errno, right?
> > Are you suggest "ENODEV"? It's a feature from the device but the device is exact here. 
> 
> Yes I think this should be ENODEV to be consistent with the
> existing drivers such as padlock-aes.c.
> 
> I'll make that change in cryptodev.
> 
> Thanks,
Thank you, Pavel and Herbert. 

