Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbYBRTW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbYBRTW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 14:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYBRTWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 14:22:22 -0500
Received: from wx-out-0506.google.com ([66.249.82.231]:54138 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbYBRTWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:22:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZqQk+wKcFw523PgQeeFNRE1/1ipfOwPzI23OmFTP1YXNjUKO1N3+616Frhss1/4ay59zBkzJU7uG60z+KqVeC1MRjfZ7UIiicgQiHyEFaLTh5lmGchJ7xe5pA6/eXhPLBf2wu09TKm2K/TPKrx/8wg176ntLzBhArG36JHj+rS4=
Message-ID: <de8d50360802181122k63410760y9a61f4c42ff251f8@mail.gmail.com>
Date: Mon, 18 Feb 2008 11:22:18 -0800
From: "Andrew Pinski" <pinskia@gmail.com>
To: "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [Cbe-oss-dev] [PATCH 1/3] Fix Unlikely(x) == y
Cc: "Adrian Bunk" <bunk@kernel.org>, "Roel Kluin" <12o3l@tiscali.nl>,
       lkml <linux-kernel@vger.kernel.org>, cbe-oss-dev@ozlabs.org,
       linuxppc-dev@ozlabs.org, "Willy Tarreau" <w@1wt.eu>,
       "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B70A61.9030306@tiscali.nl>
	 <20080216092552.325e5726@laptopd505.fenrus.org>
	 <20080216173315.GU8953@1wt.eu>
	 <20080216094226.1e8eede1@laptopd505.fenrus.org>
	 <47B72BFE.9060302@am.sony.com>
	 <20080216103927.2a02352b@laptopd505.fenrus.org>
	 <1203249003.6718.24.camel@concordia>
	 <20080218135609.GD21080@cs181133002.pp.htv.fi>
	 <Pine.LNX.4.64.0802181500410.13406@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18, 2008 6:01 AM, Geert Uytterhoeven
<Geert.Uytterhoeven@sonycom.com> wrote:
> > This means it generates faster code with a current gcc for your platform.
> >
> > But a future gcc might e.g. replace the whole loop with a division
> > (gcc SVN head (that will soon become gcc 4.3) already does
> > transformations like replacing loops with divisions [1]).

Yes but the issue is one optimization inside GCC does not take into
account the probability in one case.

And really there is a bug in the linux kernel for not implementing the
long long divide function (or really using libgcc) but that is a
different story and is part of the issue there anyways.

-- Pinski
