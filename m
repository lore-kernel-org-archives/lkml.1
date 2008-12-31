Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbYLaQvu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbYLaQvu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 11:51:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbYLaQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 11:51:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:39698 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113AbYLaQvh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 11:51:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=g0j0Aer3dLfF5MaXGAjntLz3Que2mdkIjy+IDX7Jl01QLnyIZroVgnqkmdhgZ9b2HQ
         yJ523RNlnsrd5eNjYtQljSzqotpEKtuDHkqsHSfyzUcYshVisAI7DgJnR6B/LhzKk5gX
         5NrJtKU8QAm5lYT2L7RDgL9mbQdKkL40P/cSo=
Subject: Re: [ath5k-devel] Bugs on aspire one A150
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andreas Mohr <andi@lisas.de>, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081231140308.GA26600@hash.localnet>
References: <1230641016.5770.5.camel@maxim-laptop>
	 <20081231091845.GA2516@rhlx01.hs-esslingen.de>
	 <20081231140308.GA26600@hash.localnet>
Content-Type: text/plain
Date: Wed, 31 Dec 2008 18:51:31 +0200
Message-Id: <1230742291.26499.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-12-31 at 09:03 -0500, Bob Copeland wrote:
> On Wed, Dec 31, 2008 at 10:18:45AM +0100, Andreas Mohr wrote:
> > Hi,
> > 
> > > Sure, will test, I am also sure that this will work.
> > 
> > A110L, 2.6.28, success (also inverted here, traffic blanks it).
> 
> Thanks for testing.
> 
> By inverted, do you mean that it is off when it should be on and
> vice-versa?  If so, you can change it to 'sc->led_on = 0' instead
> of 1.  Let me know if I should make that change in the patch.
> 

Actually, I even thought that this is right behavior, here on iwl3945
led is always on, and blinks while traffic is send, also same on
windows, but feel free to invert the polarity.

What does bother me is, that led state gets inverted dynamically, that
is system starts with default 'led always on', but after some time
switches to 'always led off' and after sometime again switches back.
This does seem to be software problem, at least according to sysfs
interace.

And I think led blinks too fast, sometimes it is hard to even see it.
It might even shorten led life, but this is just a guess.

Best regards,
	Maxim Levitsky

