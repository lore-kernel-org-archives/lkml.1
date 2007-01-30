Return-Path: <linux-kernel-owner+w=401wt.eu-S965467AbXA3JbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965467AbXA3JbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 04:31:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965468AbXA3JbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 04:31:11 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50479 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965467AbXA3JbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 04:31:09 -0500
Date: Tue, 30 Jan 2007 01:26:31 -0800
From: Andrew Morton <akpm@osdl.org>
To: Olivier Galibert <galibert@pobox.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.20-rc6-mm3
Message-Id: <20070130012631.8bb86c76.akpm@osdl.org>
In-Reply-To: <20070130090645.GC11823@dspnet.fr.eu.org>
References: <20070129204528.eb8d695e.akpm@osdl.org>
	<20070130090645.GC11823@dspnet.fr.eu.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jan 2007 10:06:45 +0100
Olivier Galibert <galibert@pobox.com> wrote:

> On Mon, Jan 29, 2007 at 08:45:28PM -0800, Andrew Morton wrote:
> > -x86_64-mm-share-whats-shareable.patch
> > -x86_64-mm-only-call-unreachable_devices-when-type-1-is-available.patch
> > -x86_64-mm-only-map-whats-necessary.patch
> > -x86_64-mm-detect-and-support-the-e7520-and-the-945g-gz-p-pl.patch
> > -x86_64-mm-reserve-resources-but-only-when-were-sure-about-them.patch
> 
> Want me to update these?  And maybe the other mmconfig related ones if
> I can find them.
> 

Thanks.  That depends upon which of Andi or Len merges first.

If Andi goes first, then Len has rather a bit of hackwork to do.

If Len goes first then things are probably simpler, but that ACPI codedrop
is very new and might have problems.  We wouldn't want to hold the x86
merge back because of it.

For now, I guess we sit back while Len and Andi sort out what they're going
to do.

Len, what was in that merge anyway?  Lots of renaming and shuffling things
around - the sorts of things which are safe as long as they compile OK.  But
was there much substantive material in there as well?

