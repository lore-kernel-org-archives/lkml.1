Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZCWIM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZCWIM0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755944AbZCWIMJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:12:09 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:59021 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755311AbZCWIMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UkJD00UIGe8gIb4msnV+1aNH2ybjr0yd2gSxuc74qmRyh0JTUkvi8Q+d4ERFEjltja
         XiqXW5f/D7I3kpu7FK9gnG769GPf76pIP5MgixLeNBWVak2IbmJCVeukYc0UBXoO1W/e
         vekCuO7rsrBQT8KmVHLoytuZq/kFSvqYBGRog=
Date: Mon, 23 Mar 2009 08:11:58 +0000
From: Jarek Poplawski <jarkao2@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: mpm@selenic.com, marcin.slusarz@gmail.com, netdev@vger.kernel.org,
       k-keiichi@bx.jp.nec.com, stable@kernel.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: fix BUG during net device "upping"
Message-ID: <20090323081158.GB4976@ff.dom.local>
References: <20090322.212107.55546529.davem@davemloft.net> <20090323080455.GA4976@ff.dom.local> <20090323.010541.94308473.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323.010541.94308473.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 01:05:41AM -0700, David Miller wrote:
> From: Jarek Poplawski <jarkao2@gmail.com>
> Date: Mon, 23 Mar 2009 08:04:55 +0000
> 
> > What is the rationale of this decision? printk is a basic tool,
> > especially designed to work in as many places as possible, and
> > netconsole is rather something secondary (sorry Matt)?!
> 
> And this basic tool cannot work from the drivers ->open() method.

And in any function used in the drivers ->open(). BTW, with Marcin's
patch it can...

Jarek P.
