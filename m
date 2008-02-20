Return-Path: <linux-kernel-owner+w=401wt.eu-S1763642AbYBTAou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763642AbYBTAou (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 19:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbYBTAol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 19:44:41 -0500
Received: from an-out-0708.google.com ([209.85.132.241]:16621 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYBTAok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 19:44:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DB1hU1FpA+p0CPW2LQsDb9sOcXKsx79dDJzWmFN3eppHs7BBh9L5y7t+mmujaN1BBY+huqa3dfP+nvjezaK1AyYQogHj/5Cr2M3fhdeFlixAALZJyo5bkDvIfBMYyOvjqfg0cXlOERX16b0qn+4iLbdHS0Sm8pWfvief97bn1Pw=
Message-ID: <97a0a9ac0802191644x693cd34cq6b167756df9c65f4@mail.gmail.com>
Date: Tue, 19 Feb 2008 17:44:38 -0700
From: "Gordon Farquharson" <gordonfarquharson@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [RFC] [PATCH] Fix b43 driver build for arm
Cc: "Sam Ravnborg" <sam@ravnborg.org>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, linville@tuxdriver.com,
       stefano.brivio@polimi.it, "Linus Torvalds" <torvalds@osdl.org>,
       "Andrew Morton" <akpm@osdl.org>, viro@ftp.linux.org.uk
In-Reply-To: <200802191141.26952.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <97a0a9ac0802181403ja79c32v864b093414b2755@mail.gmail.com>
	 <200802190101.27429.mb@bu3sch.de>
	 <97a0a9ac0802182059h36d32ac6o841bb0a1b766b74@mail.gmail.com>
	 <200802191141.26952.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael

On Feb 19, 2008 3:41 AM, Michael Buesch <mb@bu3sch.de> wrote:

> > [2] http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=7492d4a416d68ab4bd254b36ffcc4e0138daa8ff
> >
>
> That doesn't cause me to magically sign off this sort of patches, too.
> The sanity check is clearly broken in file2alias.c, as it checks something
> from the target kernel against the host environment it is compiled on.
> That doesn't make any sense at all.

I think that you make some good points, but I'm at a loss as to how to
fix the problem. Do you have any suggestions? Could we temporarily
apply the patch, so that people can build a kernel with the b43 driver
with a cross compiler, until a more permanent solution is found?

Gordon

-- 
Gordon Farquharson
GnuPG Key ID: 32D6D676
