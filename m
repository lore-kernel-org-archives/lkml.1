Return-Path: <linux-kernel-owner+w=401wt.eu-S1755486AbYACPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486AbYACPiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751734AbYACPht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:37:49 -0500
Received: from py-out-1112.google.com ([64.233.166.176]:21697 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbYACPhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:37:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WNfZ4y7rNQbQi4Xzygzp/FVuiZgg+Ac4MFqP98z3btKRf1IegP4GMJEq3Ln7pUimQldo6ArNZBTUPpvGJs2EFUgNMCbM4w7jG49XfAn/W7qIUMKXO0cl98UjVsN0ONhDLs5ebr5/h0r/U0cQBUpYdDEeDfSchRRO+byZPyQGECE=
Message-ID: <64bb37e0801030737r435ff2b1r6632ab98c2286f46@mail.gmail.com>
Date: Thu, 3 Jan 2008 16:37:46 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: 2.6.24-rc6-mm1
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Neil Brown" <neilb@suse.de>,
       netdev@vger.kernel.org, "Tom Tucker" <tom@opengridcomputing.com>
In-Reply-To: <20080102215706.GB6480@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com>
	 <20071228150746.42b3bbc0.akpm@linux-foundation.org>
	 <64bb37e0712290851r6d41768dk270e47884713a3de@mail.gmail.com>
	 <20071230013021.GA13603@gondor.apana.org.au>
	 <64bb37e0712291934o77a3d365h56c9c31ac8437469@mail.gmail.com>
	 <64bb37e0712311215x519b10e9kd51eb745b3b7290a@mail.gmail.com>
	 <20080101120406.GA27209@gondor.apana.org.au>
	 <64bb37e0801021029u1735bb9eta53906b123abf577@mail.gmail.com>
	 <20080102215154.GA13911@gondor.apana.org.au>
	 <20080102215706.GB6480@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 2, 2008 10:57 PM, J. Bruce Fields <bfields@fieldses.org> wrote:
> On Thu, Jan 03, 2008 at 08:51:54AM +1100, Herbert Xu wrote:
> > The two specific trees of interest would be git-nfsd and git-net.
>
> Also, if it's git-nfsd, it'd be useful to test with the current git-nfsd
> from the for-mm branch at:
>
>         git://linux-nfs.org/~bfields/linus.git for-mm
>
> and then any bisection results (even partial) from that tree would help
> immensely....

Wrong URL, its (now?) at git://git.linux-nfs.org/projects/bfields/linux.git

Using "HEAD is now at cd7e1c9... Merge commit 'server-xprt-switch^' into for-mm"
I was able to compile&install 54 packages, so this seems to be working.

Now git-fetch'ing
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.25.git

Torsten
