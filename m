Return-Path: <linux-kernel-owner+w=401wt.eu-S1765409AbYBUWdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765409AbYBUWdd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757735AbYBUWdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:33:18 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:53881 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507AbYBUWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:33:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=LH5Jhsu2KbLwwq6GQZF8axip6DepUVGyAq0yYQTVbVg2+Lk1sSvOmUOvCDcmuKrpGZydLRKs8Cp/z9KstbTUWXb1HvrP96tnjrKSndz5SzIZZnB7C/5RAggh8rIKGjQxaJ+DTapI5EgNMxM8lyXxRij5/YvobTovD6CRRQnDEto=
Date: Fri, 22 Feb 2008 01:33:03 +0300
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
Message-ID: <20080221223303.GD1846@martell.zuzino.mipt.ru>
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2> <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2> <20080221154951.GA28328@cs181133002.pp.htv.fi> <adahcg2awag.fsf@cisco.com> <20080221210124.GD28328@cs181133002.pp.htv.fi> <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 01:14:55PM -0800, Linus Torvalds wrote:
> On Thu, 21 Feb 2008, Adrian Bunk wrote:
> > Is it really intended to merge drivers without _any_ kind of review?
> 
> I'd really rather have the driver merged, and then *other* people can send 
> patches!
> 
> The thing is, that's what merging really means - people can work on it 
> sanely together. Before it's merged, it's a lot harder for people to work 
> on it unless they are really serious about that driver, so before 
> merging, the janitorial kind of things seldom happen.
> 
> So yes, I really do believe that we should merge drivers in particular a 
> lot more aggressively. I'd like to see *testing* feedback, in order to not 
> merge drivers that simply don't work well enough, but anything else? I 
> suspect other feedback is as likely to cause problems as it is to fix 
> things.
> 
> > This driver even lacks a basic "please fix the > 250 checkpatch errors" [1]
> > and similar low hanging fruits that could easily be spotted and then 
> > fixed by the submitter within a short amount of time.
> 
> Quite frankly, I've several times been *this* close (holds up fingers so 
> you can't even see between them) to just remove checkpatch entirely.

Agrh! What stopped you?!

> I'm personally of the opinion that a lot of checkpatch "fixes" are 
> anything but. That mainly concerns fixing overlong lines (where the 
> "fixed" version is usually worse than the original), but it's been true 
> for some other warnings too.

Speaking of driver, could authors please comment all those barrier()
calls and remove trailing "return;" at the end of void functions.
