Return-Path: <linux-kernel-owner+w=401wt.eu-S1756318AbYCCSBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756318AbYCCSBR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:01:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbYCCSA6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:00:58 -0500
Received: from gv-out-0910.google.com ([216.239.58.191]:24658 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064AbYCCSA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:00:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KvkLgWgUxcQjqM33PxmH2Y44Gq7Ev43ow5u567mfIfU4YfAL9vLaQt0iErH7/295CfK2I1w1z7mWyv1H76xtQzUAyPszJIPt1CCaWO2nrle2QTY7JzhFXdAiCsJJbFJv7Z5Ao5os6iKd79Z9OiNdj1ovcNcFGfTbXnWxdAWzBGE=
Message-ID: <9ea470500803031000o223e7cbcl160ce776c54db1a9@mail.gmail.com>
Date: Mon, 3 Mar 2008 19:00:52 +0100
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [BUG] 2.6.25-rc2-git3 broke cdrecord
Cc: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>, mikpe@it.uu.se,
       crmafra2@gmail.com, linux-kernel@vger.kernel.org,
       James.Bottomley@hansenpartnership.com, htejun@gmail.com,
       jens.axboe@oracle.com, linux-ide@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <47CC37CA.1040407@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080302233415.GA6258@Pilar>
	 <18379.18297.838050.536473@harpo.it.uu.se>
	 <tkrat.468fd04c47ae1a2a@s5r6.in-berlin.de>
	 <20080303172641Z.fujita.tomonori@lab.ntt.co.jp>
	 <47CBC014.9090309@s5r6.in-berlin.de>
	 <47CC37CA.1040407@s5r6.in-berlin.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 3, 2008 at 6:39 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
> I wrote:
>  > FUJITA Tomonori wrote:
>  >> On Mon, 3 Mar 2008 02:48:23 +0100 (CET)
>  >> Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>  >>> CD burning still fails for me via ide-cd, although in a
>  >>> different way than without the patch.  (Without the patch, ide-cd also
>  >>> fails like described by you for SATA.)
>  >>>
>  >>> With the patch, the failure is as follows.  I don't know if this is
>  >>> related to the data length arithmetic or something entirely different;
>  >>> all I learned so far is that 2.6.24 works.  Application log from
>  >>> 2.6.25-rc3 + Tejun's patch + Gentoo's cdrkit-1.1.6 + k3b:
>  >>
>  >> Can you try the following patch?
>  >>
>  >> http://lkml.org/lkml/2008/3/2/218
>  >
>  > Fails just like with Tejun's patch, alas.
>
>  What I see may very well be an ide-cd specific problem which is perhaps
>  already fixed in Linus' tree.  I need to update and retest.

Hi Stefan,

we have fixed a similar bug to yours and the patch went in after
2.6.25-rc3 - more specifically
bcd88ac3b2ff2eae3d0fa57a6b02d4fce5392f32 - so please test current git head wrt
burning with ide-cd.

Thanks.

>  (In any case, your patch fixes CD writing over SBP-2 and, judging from
>  the failure modes I got, is necessary for ide-cd as well.  Or Tejun's
>  patch or whatever you guys will come up with.)



-- 
Regards/Gruﬂ,
Boris
