Return-Path: <linux-kernel-owner+w=401wt.eu-S934766AbXK3CSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934766AbXK3CSv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 21:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763892AbXK3CSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 21:18:38 -0500
Received: from ozlabs.org ([203.10.76.45]:52919 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190AbXK3CSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 21:18:37 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC] [1/9] Core module symbol namespaces code and intro.
Date: Fri, 30 Nov 2007 13:18:33 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Roland Dreier <rdreier@cisco.com>, Andi Kleen <ak@suse.de>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, sam@ravnborg.org
References: <20071122343.446909000@suse.de> <20071126102533.1c774870@freepuppy.rosehill.pdx.hemminger.net> <20071129085334.5793a922@laptopd505.fenrus.org>
In-Reply-To: <20071129085334.5793a922@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711301318.34379.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 November 2007 03:53:34 Arjan van de Ven wrote:
> On Mon, 26 Nov 2007 10:25:33 -0800
>
> > Agreed. On first glance, I was intrigued but:
> >
> > 1) Why is everyone so concerned that export symbol space is large?
> > 	- does it cost cpu or running memory?
>
> yes. about 120 bytes per symbol

But this patch makes that worse, not better.

> > 	- does it cause bugs?
>
> yes, bad apis are causing bugs... sys_open is just the starter of that.

Sure, but this doesn't change the APIs, either.  We seem to have fixed 
sys_open the right way, and since we're not supposed to care about 
out-of-tree modules...

Rusty.
