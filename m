Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbYADVYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbYADVYx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:24:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYADVYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:24:41 -0500
Received: from py-out-1112.google.com ([64.233.166.178]:42267 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854AbYADVYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:24:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LgTgq2attXEzyJPxeqZeCI1jgCWsEih0rNvK5OC/tt86BiOD5R0zK/eDaKjKrKlrDW1fPvTbx4In5gK+De8nlLgHZ8cEe7Z7VGFaK//ljZlCJOpYcvzcD8vv/RcpxC77W6G8/FbRZ/bshXUmni5m/hP4+DNsPA28FHfabb5LClk=
Message-ID: <64bb37e0801041324j12184660m3c3be34e23dfd957@mail.gmail.com>
Date: Fri, 4 Jan 2008 22:24:37 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Jarek Poplawski" <jarkao2@gmail.com>
Subject: Re: 2.6.24-rc6-mm1
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Neil Brown" <neilb@suse.de>,
       "J. Bruce Fields" <bfields@fieldses.org>, netdev@vger.kernel.org,
       "Tom Tucker" <tom@opengridcomputing.com>
In-Reply-To: <64bb37e0801040721p57ff3d54wc3de00546d1d2ff1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <64bb37e0801040223q17a76565k3c7667a197403ce5@mail.gmail.com>
	 <20080104133031.GA3329@ff.dom.local>
	 <64bb37e0801040721p57ff3d54wc3de00546d1d2ff1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 4, 2008 4:21 PM, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On Jan 4, 2008 2:30 PM, Jarek Poplawski <jarkao2@gmail.com> wrote:
> > - above git-nfsd and git-net tests should be probably repeated with
> > -rc6-mm1 git versions: so vanilla rc6 plus both these -mm patches
> > only, and if bug triggers, with one reversed; btw., since in previous
> > message you mentioned that 50 packages could be not enough to trigger
> > this, these 54 above could make too little margin yet.
>
> Yes, I think I really need to redo the git-nfsd-test.
> With IOMMU_DEBUG enabled rc6-mm1worked for 52 packages, only a secound
> run of kde-packages triggered it after only 5 packages.
> I don't know what this bug hates about kdeartwork-wallpaper (triggered
> it this time) or kdeartwork-styles.

49 more (kde-)packages did work too. Still looks like it is only in -mm.

Torsten
