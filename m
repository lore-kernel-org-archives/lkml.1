Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbYGQJto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbYGQJto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYGQJtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:49:32 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:34299 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbYGQJtb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=Ox7+fCcG9gvgeqVBmtQtSch20emQINBhwvBfG7GzFtBoQ7c4WDvIyJeMKG8wmDj4Z5
         7Pc6UmDY6wCr3oCRapVHGB+8YvzxScqyTOeW3EHFBNCjSM9FjJfZ9XMtxRlI62pDdoP5
         25xWzJQZNcm/1T5wGRhD9Uu4sNcN6mAsif6RM=
Message-ID: <9ea470500807170249h5fc7ce46q3c2ef7473a22b0ba@mail.gmail.com>
Date: Thu, 17 Jul 2008 11:49:30 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: benh@kernel.crashing.org
Subject: Re: [PATCH] Fix collateral damage to top level Makefile
Cc: "Paul Mundt" <lethal@linux-sh.org>,
       "Grant Likely" <grant.likely@secretlab.ca>, jrigby@freescale.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <1216284624.7740.326.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080717070549.30755.13083.stgit@trillian.secretlab.ca>
	 <20080717072731.GB12273@linux-sh.org>
	 <1216284624.7740.326.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:50 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Thu, 2008-07-17 at 16:27 +0900, Paul Mundt wrote:
>> On Thu, Jul 17, 2008 at 01:06:55AM -0600, Grant Likely wrote:
>> > From: Grant Likely <grant.likely@secretlab.ca>
>> >
>> > The patch named "powerpc/mpc5121: Add clock driver", also contained
>> > an unrelated and bogus change to the top-level makefile.  This patch
>> > backs out the bad bit.
>> >
>> > SHA1 of offending patch: 137e95906e294913fab02162e8a1948ade49acb5)
>> >
>> > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> > ---
>> >
>> > If the maintainer who picked up this patch (Grant Likely) had done
>> > his job, this cack-up never would have happened.  Why do we still
>> > have to deal with such sloppy individuals?
>> >
>> I think the more important question is why the hell would anyone put that
>> in a Makefile, ever? ;-)
>
> Well, it's partially my fault for not spotting it when pulling in
> Grant's git and pushing out to Linus.
>
> Anyway, it's a mistake, shit happens, I doubt Grant will do that one
> twice :-)

Oh come on, don't scare the guy more than he is - now he'll be staring
frantically at each +-diff line before submitting :). And it's not like it's the
end of the world, it's just that Fred has turned 42 or similar :)

P.S. If I only knew how such an innocent thing would destroy a man's
life i never would've
reported it in the first place :). Sorry Grant.

-- 
Regards/Gruﬂ,
Boris
