Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbZAZVov@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbZAZVov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:44:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZAZVon
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:44:43 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:27690 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbZAZVom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:44:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Rz58NiCtY+1RV2WuOK5xgy3NJEJrbtFrgcX/wDGDfY1Cf/kCV2sDtLm4/VQ68UNniq
         Y87xANwBW5DdiPLCGt3p4JPbUdLlPtol0Q0LXZzahf6A8IXfP7T8OVAPRmLJqvSSHMxf
         3Otyk330Pbbg3w2Yb8b7FCLwDd6dv7Y1f4kY4=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0901261017380.5284@localhost.localdomain>
References: <alpine.DEB.2.00.0901220432480.25266@skynet.skynet.ie>
	 <alpine.LFD.2.00.0901261017380.5284@localhost.localdomain>
Date: Tue, 27 Jan 2009 07:44:40 +1000
Message-ID: <21d7e9970901261344v2909cc61m42f32f2a434df0c4@mail.gmail.com>
Subject: Re: [git pull] drm-fixes
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 4:23 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> Dave,
>  you have some odd and slightly git usage model, which shows up in various
> commits. Lookie here as an example from comit 335041ed:
>
>        Author: Jesse Barnes <jbarnes@virtuousgeek.org>  2009-01-22 04:22:06
>        Committer: Dave Airlie <airlied@redhat.com>  2009-01-22 04:22:06
>
>            drm/i915: hook up LVDS DPMS property
>
>            The LVDS output supports DPMS calls, but we never hooked up the property code,
>            so set property calls didn't actually do anything.  Implement a set_property
>            callback for the LVDS output so that the right thing happens.
>
>            Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> and this has a few issues that trigger my "Dave is doing something wrong"
> reaction:
>
>  - The signed-off-chain is incomplete from the author to the committer.
>
>   A _good_ sign-off will always have the sign-offs from the author and
>   the committer and everybody in between. This one does not. Clearly
>   Jesse did sign off on his work, but he is not listed as the committer:
>   you are. And that means that your sign-off is missing.

This one is my fault, I think I just cut-n-pasted the commit message
in my sleep,
and forgot to add my signoff.

>
>  - You are clearly lying about dates and/or dropping them.
>
>   The dates for authorship and committing are the same, yet the author
>   and committer are clearly _not_ the same. You can try to convince me
>   that you committed Jesse's work the same second he sent it to you, but
>   quite frankly, I don't buy it. End result: you've done something to
>   drop the date information

Well I'm not 100% sure what happened for this patch, I suspect,
jbarnes sent patch a week
or two ago, it misapplied against the tree I had currently when
applied with git-am, it didn't work so I hand
applied the patch with patch and then did git commit
--author="jbarnes" as he did write it, I just munged it.

Now I'm unsure how I should best handle this, in a world where I can
devote a lot more time to
maintaining this, I would sent Jesse a mail saying, rebase, he'd reply
with a rebase and I'd apply it,
however I generally find it easier to just fix this stuff up on the
run as its synchronous. Should
I be specifying a date somewhere in the commit message?

Dave.
