Return-Path: <linux-kernel-owner+w=401wt.eu-S1757851AbZLJXuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757851AbZLJXuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 18:50:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZLJXuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 18:50:17 -0500
Received: from mail-iw0-f171.google.com ([209.85.223.171]:51646 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409AbZLJXuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 18:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SPe7lQrkBCBztY50GBpPG8k98xForlKhT08X3HSdEWS8hn5yDg0873NG+Ndb5t7OE5
         5/UwDyRI59tysXN0IyQ4DAiDZ4Zi+rdJ7ipvlHDzhmzRqqrDImgwSs/O7QClJDqgPZm2
         cs7WGn0Run8Uy2oNTx3FItkRg6S0BRpznlRIs=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	 <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>
	 <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>
Date: Fri, 11 Dec 2009 09:50:21 +1000
Message-ID: <21d7e9970912101550t2a1e812nc0c35df6066d15de@mail.gmail.com>
Subject: Re: [git pull] drm
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 9:37 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 10 Dec 2009, Stephane Marchesin wrote:
>>
>> I'm not sure why people are arguing so much over this, given that no
>> nouveau devs were at the kernel summit, and we only heard rumours
>> afterwards that there were complaints about us not being ready for
>> merging.
>
> The thing is, my complaint is not about whatever external driver project.
>
> We have those all the time. I'm not complaining about Nouveau people.
>
> I'm pissed off at distribution people. For years now, distributions have
> talked about "upstream first", because of the disaster and fragmentation
> that was Linux-2.4. And most of them do it, and have been fairly good
> about it.
>
> But not only is Fedora not following the rules, I know that Fedora people
> are actively making excuses about not following the rules. I know Red Hat
> actually employs (full-time or part-time I have no idea) some Nouveau
> dveloper, and by that point Red Hat should also man up and admit that they
> need to make "merge upstream" be a priority for them.
>
> See? I'm not complaining about _you_. I'm complaining about Fedora and Red
> Hat.
>
>> If you have issues to raise about nouveau, please raise them on the
>> nouveau, mesa or dri lists, at least some time before starting to
>> complain. I must say I didn't think such a big issue was going on
>> here, that's the problem with rumours.
>
> See above. It's not you. It's Fedora. If Fedora hadn't merged Nouveau and
> shipped it, I wouldn't care.
>
> Or rather, I probably still -would- care, but I would care because nVidia
> hardware is common, and I like open source drivers. But I wouldn't be
> disappointed and pissed off.
>
> And this has been going on for a _loong_ time now. Fedora has been
> shipping Nouveau for about a year now, I think.

Its been shipping it for 2-3 years now, nouveau was a userspace X.org
driver with a normal drm, we never wanted to upstream that but we need
to get some exposure on it before the KMS effort took place. In my opinion
barring the legal issue, nouveau has only been in an upstreamable state
for about 2-3 months now, since it relied on a lot of core infrastructure
we upstreamed with radeon KMS. So the delay isn't as major as you seem
to think. The core TTM infrastructure we based radeon and nouveau on in F10,
and F11 wasn't in any state suitable for upstream, however we felt it would
help to expose the modesetting pieces to users before then to get them tested
independent of the core DRM status. So Red Hat have been putting a lot of
time and effort into upstreaming this driver, however until the ctxprog issues
is resolved to our satisfaction, no Red Hat employee can add a Signed-off-by
to this code. Why this doesn't affect Fedora so far is because its an
open question
with our lawyers, if they decide that we need to pull this from Fedora we will,
until they do we are living with the status quo.

Dave.
