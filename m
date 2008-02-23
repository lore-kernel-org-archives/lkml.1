Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbYBWNIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbYBWNIz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 08:08:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756680AbYBWNIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 08:08:39 -0500
Received: from wx-out-0506.google.com ([66.249.82.228]:30633 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548AbYBWNIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 08:08:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=uzy3m/+NzmbZ/mpKT2SIWVhAsvAQ6U/13J1eAdiUXshNMaUvor/3NRt2LuHE0yx1iS+OwMbRH+j1d7QzHNbfdamr7RXPzUWVjsQs2TpgAejkCXcND6G71t3TsvTUAFoevrcb13fDjf0PCT+HKsqUTCG7CzFHjHo+UyC7V1TxBCk=
Message-ID: <998d0e4a0802230508w12f236baiaf2d9ab5f364670a@mail.gmail.com>
Date: Sat, 23 Feb 2008 14:08:35 +0100
From: "J.C. Pizarro" <jcpiza@gmail.com>
To: "Charles Bailey" <charles@hashpling.org>,
       LKML <linux-kernel@vger.kernel.org>, git@vger.kernel.org
Subject: Re: Question about your git habits
In-Reply-To: <20080223113952.GA4936@hashpling.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008/2/23, Charles Bailey <charles@hashpling.org> wrote:
> On Sat, Feb 23, 2008 at 03:47:07AM +0100, J.C. Pizarro wrote:
>  >
>  > Yesterday, i had git cloned git://foo.com/bar.git   ( 777 MiB )
>  >  Today, i've git cloned git://foo.com/bar.git   ( 779 MiB )
>  >
>  >  Both repos are different binaries , and i used 777 MiB + 779 MiB = 1556 MiB
>  >  of bandwidth in two days. It's much!
>  >
>  >  Why don't we implement "binary delta between old git repo and recent git repo"
>  >  with "SHA1 built git repo verifier"?
>  >
>  >  Suppose the size cost of this binary delta is e.g. around 52 MiB instead of
>  >  2 MiB due to numerous mismatching of binary parts, then the bandwidth
>  >  in two days will be 777 MiB + 52 MiB = 829 MiB instead of 1556 MiB.
>  >
>  >  Unfortunately, this "binary delta of repos" is not implemented yet :|
>
>
> It sounds like what concerns you is the bandwith to git://foo.bar. If
>  you are cloning the first repository to somewhere were the first
>  clone is accessible and bandwidth between the clones is not an issue,
>  then you should be able to use the --reference parameter to git clone
>  to just fetch the missing ~2 MiB from foo.bar.
>
>  A "binary delta of repos" should just be an 'incremental' pack file
>  and the git protocol should support generating an appropriate one. I'm
>  not quite sure what "not implemented yet" feature you are looking for.

But if the repos are aggressively repacked then the bit to bit differences
are not ~2 MiB.
