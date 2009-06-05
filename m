Return-Path: <linux-kernel-owner+w=401wt.eu-S1753678AbZFEHP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbZFEHP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZFEHPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:15:45 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:27296 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbZFEHPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:15:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bJRZoMeBqmr+h9//49gt7uz6T+mEYTH9g01herLNGdOKxj/XkbLOrM/A2oqQeH4ZqL
         tdMWUClWCAfGALmEYoLj1qpfZ8z7U1iCl1mbaR5+COBfpe7ssUuJF6K5AbofhdACfdoA
         a4/KZlvfQ4ZuGSj3AiiJVcXH4glS//X9ziq5o=
Date: Fri, 5 Jun 2009 11:15:29 +0400
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-wireless@vger.kernel.org, slapin@ossfans.org, davem@davemloft.net,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 3/5] net: add NL802154 interface for configuration of
	802.15.4 devices
Message-ID: <20090605071529.GA7064@doriath.ww600.siemens.net>
References: <1244168990-28355-1-git-send-email-dbaryshkov@gmail.com> <1244168990-28355-2-git-send-email-dbaryshkov@gmail.com> <1244168990-28355-3-git-send-email-dbaryshkov@gmail.com> <1244168990-28355-4-git-send-email-dbaryshkov@gmail.com> <1244184737.22576.94.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244184737.22576.94.camel@johannes.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 05, 2009 at 08:52:17AM +0200, Johannes Berg wrote:
> On Fri, 2009-06-05 at 06:29 +0400, Dmitry Eremin-Solenikov wrote:
> 
> > +/* This source file is shared between kernel and userspace sources, thus
> > + * a bit of __KERNEL__ checks
> > + */
> > +#ifdef __KERNEL__
> 
> It's a C file. It can't be shared expect by copying, hence IMO these
> things are pointless.

It is shared by copying. And I'd strongly prefer to have it shared
directly by 'cp', not by 'cp' and 'patch'. E.g. currently I can ensure
that policy definitions and commands are current just by comparing
files. I'd like to still have that ability. Thus, I'd ask to permit this
stuff in.

-- 
With best wishes
Dmitry

