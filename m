Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261AbYIWPS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbYIWPS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbYIWPSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:18:48 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:63645 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYIWPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:18:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eLu1ZzPjKpM90yTWF1JeFP1qpgfMB0v0N9u5GKgd/Hsqz23UYeq6FezbbEaRIt+7AO
         dG5mWUkdqJEx1FHQl2cRn09Tb+jIXMoYJw4qeLAubPZDb5Ya2um8xnJw9XSNhSXRu5yi
         3GiO84Te7LP/r6dAtsp4veVVac1U9tG1+6bUg=
Date: Tue, 23 Sep 2008 19:20:53 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: david@lang.hm, James Morris <jmorris@namei.org>,
       Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
Message-ID: <20080923152053.GA6622@x200.localdomain>
References: <48C65E9D.3070106@nttdata.co.jp> <5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com> <20080910134540.45ec1272.akpm@linux-foundation.org> <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp> <alpine.LRH.1.10.0809231604040.25628@tundra.namei.org> <alpine.DEB.1.10.0809222310450.25430@asgard.lang.hm> <1222182167.28396.11.camel@moss-spartans.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222182167.28396.11.camel@moss-spartans.epoch.ncsc.mil>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:02:47AM -0400, Stephen Smalley wrote:
> 
> On Mon, 2008-09-22 at 23:12 -0700, david@lang.hm wrote:
> > On Tue, 23 Sep 2008, James Morris wrote:
> > 
> > > On Wed, 17 Sep 2008, Kentaro Takeda wrote:
> > >
> > >> TOMOYO Linux needs method for calculating pathname in LSM module.
> > >> However, we have received comment from Al Viro, the vfs maintainer,
> > >> that adding vfsmount parameter to vfs helper functions (and LSM hooks)
> > >> is not preferable. We have asked some people (including Al), and we
> > >> came back to the most straightforward approach; adding new LSM hooks
> > >> where vfsmount is available.
> > >>
> > >> The attached patch introduces several new LSM hooks TOMOYO Linux
> > >> needs. It has less impact to existing LSM module and no impact to vfs
> > >> helper functions. Please review it.
> > >
> > > I don't see any technical errors in this patch.
> > >
> > > If it is going to be merged, please make a new config option for
> > > path-based hooks (similar to that for the network hooks), so they can be
> > > compiled out.

Another pointless config option.

It's actually pretty surprising that SECURITY_NETWORK is
a) user-visible and b) is not SECURITY && NET.

Same for SECURITY_NETWORK_XFRM.
