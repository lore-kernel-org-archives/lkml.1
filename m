Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbZLJUfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbZLJUfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 15:35:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756442AbZLJUfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 15:35:04 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56520 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbZLJUfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 15:35:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ifl1sJfxm2WetoHAilUdpQNkk4K0twHO4KiLvxu/mVZi4KeaXuWEIJ3GsMxFmQ7FAx
         +egVymyEU4HJrPeIitfG8JCcfecEwLFqDFDsMOZn0H19CnALmsgCbvY5becPiCgT128z
         OmUWQ9BSm+R9LYeP0unKDZueWNICGQeLWEwm8=
MIME-Version: 1.0
In-Reply-To: <20091210214948.3d3c958c@daedalus.pq.iki.fi>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>
	 <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>
	 <1260459601.18520.26.camel@skunk>
	 <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>
	 <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
	 <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>
	 <20091210214948.3d3c958c@daedalus.pq.iki.fi>
Date: Thu, 10 Dec 2009 15:35:08 -0500
Message-ID: <8e6f94720912101235l30d05c03m54b769d9fd6ac35d@mail.gmail.com>
Subject: Re: [git pull] drm
From: Will Dyson <will.dyson@gmail.com>
To: Pekka Paalanen <pq@iki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@linux.ie>, Xavier Bestel <xavier.bestel@free.fr>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 10, 2009 at 2:49 PM, Pekka Paalanen <pq@iki.fi> wrote:

> The big question is what we call ctxprogs: binary blobs that are
> clearly executable, running somewhere in the GPU. No-one seems
> to know, if those are copyrightable, or if they can be redistributed.
> In their current form, they have been recorded from the nvidia
> proprietary driver using mmiotrace, and copied verbatim for each
> card type.
>
> Would you be willing to pull that kind of stuff into Linux?
>
> I would not even dare sending them to the Linux firmware
> repository, since they have some license requirements, too.

This seems similar to the unfortunate situation with the b43 wireless
card firmware. Broadcom refuses to provide the firmware under a
redistributable license (or even as files separate from their
proprietary drivers). This did not stop b43 from being included in
Linux. Distributions have dealt with it by providing a script that
downloads the proprietary driver and extracts the firmware from it to
files in /lib/firmware.

Do you think that a similar solution for nouveau would be legally
problematic? Or is the issue technical, since you mention that the
ctxprogs were obtained by mmiotrace, instead of a more straightforward
extraction from the binary driver blobs?

-- 
Will Dyson
