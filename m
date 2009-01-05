Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbZAEQdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbZAEQdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:33:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751853AbZAEQdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:33:21 -0500
Received: from mail.fieldses.org ([141.211.133.115]:32794 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbZAEQdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:33:20 -0500
Date: Mon, 5 Jan 2009 11:33:12 -0500
To: Chris Mason <chris.mason@oracle.com>
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: Btrfs for mainline
Message-ID: <20090105163312.GA16883@fieldses.org>
References: <1230722935.4680.5.camel@think.oraclecorp.com> <1230924749.7538.35.camel@think.oraclecorp.com> <20090102210104.GC496@one.firstfloor.org> <200901052107.43341.chris@csamuel.org> <1231161538.4290.12.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231161538.4290.12.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 08:18:58AM -0500, Chris Mason wrote:
> On Mon, 2009-01-05 at 21:07 +1100, Chris Samuel wrote:
> > On Sat, 3 Jan 2009 8:01:04 am Andi Kleen wrote:
> > 
> > > When it's in mainline I suspect people will start using it for that.
> > 
> > Some people don't even wait for that. ;-)
> > 
> > Seriously though, if that is a concern can I suggest taking the btrfsdev route 
> > and, if you want a real belt and braces approach, perhaps require it to have a 
> > mandatory mount option specified to successfully mount, maybe "eat_my_data" ?
> 
> I think ext4dev made more sense for ext4 because people generally expect
> ext* to be stable.  Btrfs doesn't quite have the reputation for
> stability yet, so I don't feel we need a special -dev name for it.

Old kernel versions may still get booted after brtfs has gotten a
reputation for stability.  E.g. if I move my / to brtfs in 2.6.34, then
one day need to boot back to 2.6.30 to track down some regression, the
reminder that I'm moving back to some sort of brtfs dark-ages might be
welcome.

(Not that I have particularly strong feelings about this.)

--b.

> 
> But, if Andrew/Linus prefer that unstable filesystems are tagged with
> -dev, I'm happy to do it.
> 
> -chris
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
