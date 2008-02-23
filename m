Return-Path: <linux-kernel-owner+w=401wt.eu-S1756563AbYBWNhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563AbYBWNhS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:37:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYBWNhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:37:04 -0500
Received: from ti-out-0910.google.com ([209.85.142.185]:47901 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbYBWNhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:37:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=R39/cM3xSzwYw5H9Gi6Og/EaTLVs1ChPusfT4F9ystuMnkNN2TMd4dT2GtD03L4pEHJxTMab6OMLGW4Z6cOgkmTozgANiiWsWxzo3ZZWeIRL0b6K/cZeiQFqPg4GMTEQ89k4PTL9guqvqG7IpSE0+ISxha9uyYs4eDOagogJuDc=
Message-ID: <998d0e4a0802230536w74e93ec3s40c77d52b183a419@mail.gmail.com>
Date: Sat, 23 Feb 2008 14:36:59 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Charles Bailey" <charles@hashpling.org>,
       LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: Re: Question about your git habits
In-Reply-To: <20080223131749.GA5811@hashpling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802221837.37680.chase.venters@clientec.com>
	 <Pine.LNX.4.64.0802230221140.21077@fbirervta.pbzchgretzou.qr>
	 <20080223014445.GK27894@ZenIV.linux.org.uk>
	 <7vfxvk4f07.fsf@gitster.siamese.dyndns.org>
	 <20080223020913.GL27894@ZenIV.linux.org.uk>
	 <998d0e4a0802221823h3ba53097gf64fcc2ea826302b@mail.gmail.com>
	 <998d0e4a0802221847m431aa136xa217333b0517b962@mail.gmail.com>
	 <20080223113952.GA4936@hashpling.org>
	 <998d0e4a0802230508w12f236baiaf2d9ab5f364670a@mail.gmail.com>
	 <20080223131749.GA5811@hashpling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/2/23, Charles Bailey <charles@hashpling.org> wrote:
> On Sat, Feb 23, 2008 at 02:08:35PM +0100, J.C. Pizarro wrote:
>  >
>  > But if the repos are aggressively repacked then the bit to bit differences
>  > are not ~2 MiB.
>
>
> It shouldn't matter how aggressively the repositories are packed or what
>  the binary differences are between the pack files are. git clone
>  should (with the --reference option) generate a new pack for you with
>  only the missing objects. If these objects are ~52 MiB then a lot has
>  been committed to the repository, but you're not going to be able to
>  get around a big download any other way.

You're wrong, nothing has to be commited ~52 MiB to the repository.

I'm not saying "commit", i'm saying

"Assume A & B binary git repos and delta_B-A another binary file, i
request built
B' = A + delta_B-A where is verified SHA1(B') = SHA1(B) for avoiding
corrupting".

Assume B is the higher repacked version of "A + minor commits of the day"
as if B was optimizing 24 hours more the minimum spanning tree. Wow!!!
