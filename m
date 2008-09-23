Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYIWPDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYIWPDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 11:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYIWPDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 11:03:38 -0400
Received: from zombie2.ncsc.mil ([144.51.88.133]:40993 "EHLO zombie2.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbYIWPDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 11:03:38 -0400
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
From: Stephen Smalley <sds@tycho.nsa.gov>
To: david@lang.hm
Cc: James Morris <jmorris@namei.org>, Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
In-Reply-To: <alpine.DEB.1.10.0809222310450.25430@asgard.lang.hm>
References: <48C65E9D.3070106@nttdata.co.jp>
	 <5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com>
	 <20080910134540.45ec1272.akpm@linux-foundation.org>
	 <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp>
	 <alpine.LRH.1.10.0809231604040.25628@tundra.namei.org>
	 <alpine.DEB.1.10.0809222310450.25430@asgard.lang.hm>
Content-Type: text/plain
Organization: National Security Agency
Date: Tue, 23 Sep 2008 11:02:47 -0400
Message-Id: <1222182167.28396.11.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-09-22 at 23:12 -0700, david@lang.hm wrote:
> On Tue, 23 Sep 2008, James Morris wrote:
> 
> > On Wed, 17 Sep 2008, Kentaro Takeda wrote:
> >
> >> TOMOYO Linux needs method for calculating pathname in LSM module.
> >> However, we have received comment from Al Viro, the vfs maintainer,
> >> that adding vfsmount parameter to vfs helper functions (and LSM hooks)
> >> is not preferable. We have asked some people (including Al), and we
> >> came back to the most straightforward approach; adding new LSM hooks
> >> where vfsmount is available.
> >>
> >> The attached patch introduces several new LSM hooks TOMOYO Linux
> >> needs. It has less impact to existing LSM module and no impact to vfs
> >> helper functions. Please review it.
> >
> > I don't see any technical errors in this patch.
> >
> > If it is going to be merged, please make a new config option for
> > path-based hooks (similar to that for the network hooks), so they can be
> > compiled out.
> 
> one question about these new hook locations.
> 
> it is possible to gather all the info that was gathered at the old hook 
> locations from the new ones? I realize that you are not eliminating the 
> old hooks (and possibly can't for backwards compatibility), but possibly 
> they should be depriciated in favor of the new locations if they can 
> satisfy both the old uses and new use cases.

They can't.

-- 
Stephen Smalley
National Security Agency

