Return-Path: <linux-kernel-owner+w=401wt.eu-S1753612Ab0AZVi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab0AZVi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 16:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808Ab0AZVi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 16:38:26 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:43818 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab0AZViZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 16:38:25 -0500
Date: Tue, 26 Jan 2010 14:38:03 -0700
From: Alex Chiang <achiang@hp.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-rdma@vger.kernel.org, justin.chen@hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: infiniband limit of 32 cards per system?
Message-ID: <20100126213803.GA12035@ldl.fc.hp.com>
References: <20100125235013.GD2828@grease.ALLEYCAT> <adaiqapplv7.fsf@roland-alpha.cisco.com> <20100126035906.GA23347@ldl.fc.hp.com> <adaaaw1pl5d.fsf@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaaaw1pl5d.fsf@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roland Dreier <rdreier@cisco.com>:
> 
>  > I'm guessing that it's not just a simple kernel fix though since
>  > OFED has to change too, right?
> 
> Dunno about OFED.  Nothing sane is hard-coding major/minor numbers
> though -- so I think OFED should be OK, asuming there are no crazy
> scripts that bypass udev creating device nodes etc.

Ok.

> I don't think that it's _totally_ trivial in the kernel -- we
> do need to add some code in several places to allocate dynamic
> device numbers when we run out of the static allocation
> (probably best to keep the legacy device numbers for "small" <
> 32 adapter systems, since there may be really small systems
> with static hard-coded /dev etc).

I take it this concern is what prevents us from simply increasing
IB_UVERBS_MAX_DEVICES to 64 or something?

thanks,
/ac
