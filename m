Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbXHVQXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbXHVQXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 12:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765211AbXHVQXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 12:23:30 -0400
Received: from 1wt.eu ([62.212.114.60]:2250 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932466AbXHVQX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 12:23:28 -0400
Date: Wed, 22 Aug 2007 18:10:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Ayaz Abdulla <aabdulla@nvidia.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       netdev@vger.kernel.org
Subject: Re: [2.6.20.17 review 35/58] forcedeth bug fix: realtek phy
Message-ID: <20070822161017.GB11973@1wt.eu>
References: <20070822083844.%N@1wt.eu> <20070822084026.%N@1wt.eu> <46CC5CBA.2050901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46CC5CBA.2050901@redhat.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 11:56:42AM -0400, Chuck Ebbert wrote:
> On 08/22/2007 05:39 AM, Willy Tarreau wrote:
> > This patch contains errata fixes for the realtek phy. It only renamed the
> > defines to be phy specific.
> > 
> > Signed-off-by: Ayaz Abdulla <aabdulla@nvidia.com>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Willy Tarreau <w@1wt.eu>
> > ---
> >  drivers/net/forcedeth.c |   54 +++++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 54 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/forcedeth.c b/drivers/net/forcedeth.c
> > index c383dc3..dbfdbed 100644
> > --- a/drivers/net/forcedeth.c
> > +++ b/drivers/net/forcedeth.c
> > @@ -554,6 +554,7 @@ union ring_type {
> >  #define PHY_OUI_MARVELL	0x5043
> >  #define PHY_OUI_CICADA	0x03f1
> >  #define PHY_OUI_VITESSE	0x01c1
> > +#define PHY_OUI_REALTEK	0x01c1
> >  #define PHYID1_OUI_MASK	0x03ff
> >  #define PHYID1_OUI_SHFT	6
> >  #define PHYID2_OUI_MASK	0xfc00
> 
> Realtek is 0x0732
> 
> This is still wrong upstream -- what happened to the patch to fix it?

Good catch, thanks Chuck! I've already seen the fix somewhere, I believe it
was on netdev, though I'm not sure. I'm fixing the patch in place right now.
I can add your signoff if you want.

Cheers,
Willy

