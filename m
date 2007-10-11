Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbXJKEu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbXJKEu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 00:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752305AbXJKEuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 00:50:14 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:6471 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbXJKEuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 00:50:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=IAn570qAu9BjjRbP9bp6TiJX4AS+2DZTwCYH3DyceBFgLnOAIvEOoakoLI7LQpiwN45w1sQIamUneosLiveTfu+fU6slkDPV22FWhrki+TQq5UeJj0OuZBuBFJ+/hpNiQE6py7NFXxnxaHumO4NFfMkn5QCcqmWwnaskjMXBivY=
Message-ID: <d9def9db0710102150l3aa0626es90184c24875bc2e9@mail.gmail.com>
Date: Thu, 11 Oct 2007 06:50:12 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [v4l-dvb-maintainer] [GIT PATCHES] V4L/DVB changes for 2.6.24
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       linux-dvb-maintainer@linuxtv.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       video4linux-list@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1192053794.15601.47.camel@gaivota>
	 <d9def9db0710101600m79bd52e5s210d28630469b1c9@mail.gmail.com>
	 <alpine.LFD.0.999.0710101639550.20690@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 11 Oct 2007, Markus Rechberger wrote:
> >
> > the chances of the em28xx are not accepted from my side since the latest
> code
> > which supports way more hardware is offtree for various reasons.
>
> Well, I've talked to various people, and none of the main kernel people
> end up being at all interested in a kernel that has external dependencies
> on binary blobs for tuners.
>

the drivers are all opensource and the code is available.

> So right now it seems like while I would personally want to have more
> vendors supprt their own drivers, if that in this case means that we'd
> have to have user-space and unmaintainable binaries to tune the cards,
> everybody seems to hate that idea.
>

For me the reason is that some drivers in the kernel which that driver
depends on are broken now. Those drivers got broken by several people
who disagree with me.
My conclusion after providing patches to fix those things is that I
won't run after those people anymore. I'm not going to have further
discussions with those people about it since there are enough other
outstanding things to do with that driver. After 1 1/2 years I'm just
fed up with it now and I want to continue to improve the driver.

> As such, the old and decrepit em28xx driver seems more useful to people,
> since at least it supports the limited set of hardware on its own.

it does not since it's broken and feature limited. On the other side
it requires a firmware from userspace too so I don't think it matters
at all if the algorithm is done in kernelspace or userspace since it
depends on such a blob (and I cannot get the source for that firmware,
if someone's interested in that he has to disassemble the firmware).

Markus
