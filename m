Return-Path: <linux-kernel-owner+w=401wt.eu-S1758384AbYCASkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384AbYCASkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 13:40:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYCASkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 13:40:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:2997 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408AbYCASkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 13:40:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=xJpQ/SNBujQrsEOZ8yZZtkGJYKtcZ9ATPMXiPiJ+/wqDYln6uK7w7GnNZtpDz04pjTfmK3GHrjvHfPBvi1qZNbyeeetSHRRLwvXygTh9Hk2uXkRvrcfDRFiR/qD39Mmr9LA16ZKZt/dovd1rXVxo3+SPiSs+eB0RJ7umRLzc7uM=
Message-ID: <524f69650803011040j6804ddcay4aa94f216bdf907f@mail.gmail.com>
Date: Sat, 1 Mar 2008 12:40:06 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: [PATCH][fs/cifs/cifsfs.c] Make use of cifs_xquota_get
Cc: "Roel Kluin" <12o3l@tiscali.nl>, sfrench@samba.org,
       linux-cifs-client@lists.samba.org, samba-technical@lists.samba.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <524f69650803011029w50d16badkc52c2591c8113a99@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B08A0B.4020604@tiscali.nl>
	 <20080301093712.GB25835@cs181133002.pp.htv.fi>
	 <524f69650803010806m1571df8fiff4b9587b7bf1cc7@mail.gmail.com>
	 <20080301161515.GD25835@cs181133002.pp.htv.fi>
	 <524f69650803011029w50d16badkc52c2591c8113a99@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without changing my tree - cg-diff against mainline now shows

 5525 files changed, 291635 insertions(+), 134707 deletions(-)

where last time I checked about a week ago it showed only a few
hundred lines changed.

Any idea what happened to mainline git tree?

On Sat, Mar 1, 2008 at 12:29 PM, Steve French <smfrench@gmail.com> wrote:
> On Sat, Mar 1, 2008 at 10:15 AM, Adrian Bunk <bunk@kernel.org> wrote:
>  > On Sat, Mar 01, 2008 at 10:06:11AM -0600, Steve French wrote:
>  >  > There are quite a few fixes stuck in cifs-2.6.git that are fine to be
>  >  > merged with mainline but didn't want to bug Linus with multiple merge
>  >  > requests (there are a couple of more fixes that are not in
>  >  > cifs-2.6.git pending review)
>  Just tried to check my cifs-2.6 tree on kernel.org and forward the merge
>  request off to Linus but it looks like the mainline tree has been rebuilt
>  (git diff shows "warning: no common commits").  Am syncing again.
>
>
>
>  >  But generally please try to get fixes to Linus early - and having a few
>  >  more weeks for getting fixes tested is more important than how often
>  >  Linus pulls from you.
>  >
>  >  > Thanks,
>  >  >
>  >  > Steve
>  >
>  >  cu
>  >
>  >
>  > Adrian
>  >
>  >  --
>  >
>  >        "Is there not promise of rain?" Ling Tan asked suddenly out
>  >         of the darkness. There had been need of rain for many days.
>  >        "Only a promise," Lao Er said.
>  >                                        Pearl S. Buck - Dragon Seed
>  >
>  >
>
>
>
>  --
>  Thanks,
>
>  Steve
>



-- 
Thanks,

Steve
