Return-Path: <linux-kernel-owner+w=401wt.eu-S1030273AbXBAE1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273AbXBAE1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 23:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbXBAE1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 23:27:16 -0500
Received: from hera.kernel.org ([140.211.167.34]:38574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbXBAE1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 23:27:15 -0500
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Andrew Morton <akpm@osdl.org>
Subject: Re: 2.6.20-rc6-mm3
Date: Wed, 31 Jan 2007 23:25:48 -0500
User-Agent: KMail/1.9.5
Cc: Olivier Galibert <galibert@pobox.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
References: <20070129204528.eb8d695e.akpm@osdl.org> <20070130090645.GC11823@dspnet.fr.eu.org> <20070130012631.8bb86c76.akpm@osdl.org>
In-Reply-To: <20070130012631.8bb86c76.akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200701312325.48781.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 January 2007 04:26, Andrew Morton wrote:
> On Tue, 30 Jan 2007 10:06:45 +0100
> Olivier Galibert <galibert@pobox.com> wrote:
> 
> > On Mon, Jan 29, 2007 at 08:45:28PM -0800, Andrew Morton wrote:
> > > -x86_64-mm-share-whats-shareable.patch
> > > -x86_64-mm-only-call-unreachable_devices-when-type-1-is-available.patch
> > > -x86_64-mm-only-map-whats-necessary.patch
> > > -x86_64-mm-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
> > > -x86_64-mm-reserve-resources-but-only-when-were-sure-about-them.patch
> > 
> > Want me to update these?  And maybe the other mmconfig related ones if
> > I can find them.
> > 
> 
> Thanks.  That depends upon which of Andi or Len merges first.
> 
> If Andi goes first, then Len has rather a bit of hackwork to do.
> 
> If Len goes first then things are probably simpler, but that ACPI codedrop
> is very new and might have problems.  We wouldn't want to hold the x86
> merge back because of it.

I think chances are actually quite good we'll be able to proceed with
pushing the ACPI table re-write immediately upon 2.6.21 open.

Note that while it is sort of big text-wise, it isn't that complicated --
and failures in this type of code tend to be massively obvious boot failures.
Note also that  2.6.20-rc6-mm3 is not the maiden voyage to -mm for this code.
It has been there several times before as it has matured.

The table re-write broke the HP simulator -- but I think we can fix that quickly.
I don't know yet what broke the HP rx2600.
The sysfs branch is what broke the button and the Altix boot.
Sysfs may or may not go upstream at 2.6.21 open -- but that isn't
the code you are conflicting with here so that is moot.

cheers,
-Len


> For now, I guess we sit back while Len and Andi sort out what they're going
> to do.
> 
> Len, what was in that merge anyway?  Lots of renaming and shuffling things
> around - the sorts of things which are safe as long as they compile OK.  But
> was there much substantive material in there as well?
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
