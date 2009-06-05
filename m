Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZFEHy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZFEHy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754719AbZFEHyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:54:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36936
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754630AbZFEHyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:54:17 -0400
Date: Fri, 05 Jun 2009 00:54:18 -0700 (PDT)
Message-Id: <20090605.005418.07362083.davem@davemloft.net>
To: dbaryshkov@gmail.com
Cc: johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       slapin@ossfans.org, sfr@canb.auug.org.au
Subject: Re: [PATCH 3/5] net: add NL802154 interface for configuration of
 802.15.4 devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090605071529.GA7064@doriath.ww600.siemens.net>
References: <1244168990-28355-4-git-send-email-dbaryshkov@gmail.com>
	<1244184737.22576.94.camel@johannes.local>
	<20090605071529.GA7064@doriath.ww600.siemens.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Fri, 5 Jun 2009 11:15:29 +0400

> On Fri, Jun 05, 2009 at 08:52:17AM +0200, Johannes Berg wrote:
>> On Fri, 2009-06-05 at 06:29 +0400, Dmitry Eremin-Solenikov wrote:
>> 
>> > +/* This source file is shared between kernel and userspace sources, thus
>> > + * a bit of __KERNEL__ checks
>> > + */
>> > +#ifdef __KERNEL__
>> 
>> It's a C file. It can't be shared expect by copying, hence IMO these
>> things are pointless.
> 
> It is shared by copying. And I'd strongly prefer to have it shared
> directly by 'cp', not by 'cp' and 'patch'. E.g. currently I can ensure
> that policy definitions and commands are current just by comparing
> files. I'd like to still have that ability. Thus, I'd ask to permit this
> stuff in.

You can maintain your own code in your own directories in your
own source tree however you like.

But if you want you code in the upstream kernel, you have to clean it
of things like this.

I agree with Johannes, you have to get rid of this.
