Return-Path: <linux-kernel-owner+w=401wt.eu-S1754752AbYABC3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbYABC3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 21:29:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYABC3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 21:29:43 -0500
Received: from hs-out-0708.google.com ([64.233.178.251]:57684 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751703AbYABC3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 21:29:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lUODu6kEMeLzTj6wNkKVykBBl3eu0G/iEHkDtdQzqCDAtIG3WgwIWxdc+FYb2i0KMHuw5gJcuirivQ+anealNAt0EuXPoLaf9a52XbOJc3LAtCCGw9YcPHQw9QjxGnYTjNaiywTa/EqN774Bdz3COkzaKRCLdUaGKSNqSFOfV24=
Message-ID: <a8e1da0801011829p15da81dcw9db0f7cbb5444467@mail.gmail.com>
Date: Wed, 2 Jan 2008 10:29:41 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 06/12] pci : Use mutex instead of semaphore in driver core
Cc: "Matthew Wilcox" <matthew@wil.cx>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <477632A7.6050208@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071229011057.GG2883@darkstar.te-china.tietoenator.com>
	 <20071229025506.GL11638@parisc-linux.org>
	 <477632A7.6050208@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 29, 2007 7:42 PM, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> Matthew Wilcox wrote:
> > Patches should be self-contained for ease of bisecting.  I can't tell
> > whether this patch is correct or not because you haven't included all
> > the other places that need to change at the same time as this.
>
> I think a broken-up patch series isn't totally wrong to do for a first
> look at these RFC patches.  Of course the series needs to become a
> single patch before it is committed to a tree whose history needs to
> support bijection, e.g. -mm.
>
> However, Dave's postings lack a References: header which refer to his
> 00/12 posting.

Thanks.  I agree with you, for bitsection it should be a single one.

>
> (Also, a bonus in the 00/12 posting would be a listing of all patch
> titles in the series and the total diffstat of the series, but nearly
> nobody does this.)

Your sugestion is better.

And, andrew recommends not to use 00/xx introduction email in series
in his "The perfect patch":
http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

> --
> Stefan Richter
> -=====-=-=== ==-- ===-=
> http://arcgraph.de/sr/
>
