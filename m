Return-Path: <linux-kernel-owner+w=401wt.eu-S1765667AbYEGUSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765667AbYEGUSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 16:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYEGUSZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 16:18:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:23476 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240AbYEGUSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 16:18:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n7P5raBOUMZSB0ja5Q6sVNUVCwr7iK2P4AGDJ0pBbahh2tOQgCkJ2pUbH4UY/OpnAZ1XRYGMA8Ju9JriPeR7HJt/RgDv5N+WyGOQqW+MXfF6sQvLjHMqStW4gAUMPxPJAPEYZ1Ivdp3vXqcT0tVyi2Nmv1eN87FRlIjU9wRKmM8=
Message-ID: <86802c440805071318u6b9d7f67gaa7d92ae6c3df079@mail.gmail.com>
Date: Wed, 7 May 2008 13:18:22 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Rene Herman" <rene.herman@keyaccess.nl>
Subject: Re: 2.6.26, PAT and AMD family 6
Cc: "Daniel Hazelton" <dhazelton@enter.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>, hpa@zytor.com
In-Reply-To: <86802c440805071316p39b7f370u46fa4f36c420bce7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48210A71.1060409@keyaccess.nl>
	 <86802c440805061939q39ff5500h3c9e229ecbc6b2e6@mail.gmail.com>
	 <4821A7E2.6080101@keyaccess.nl>
	 <200805071539.32594.dhazelton@enter.net>
	 <48220BC1.2050701@keyaccess.nl>
	 <86802c440805071316p39b7f370u46fa4f36c420bce7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 7, 2008 at 1:16 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Wed, May 7, 2008 at 1:06 PM, Rene Herman <rene.herman@keyaccess.nl> wrote:
>  > On 07-05-08 21:39, Daniel Hazelton wrote:
>  >
>  >
>  > > HPA asked about why they used a whitelist instead of a blacklist in [1].
>  > The answer (in [2]) was that those are the CPU's that are guaranteed to
>  > properly support PAT (no known or potential errata). However in [3] Dean
>  > Gaudet complained about the AMD detection code having a limit that the Intel
>  > detection code did not.
>  > >
>  >
>  >  And in that thread both HPA and Ingo Molnar -- two of the three x86 arch
>  >  maintainers -- agreed that a whitelist is the wrong approach, with HPA
>  >  commenting that it lead to vendor lockin. And here I am talkng to an
>  >  Intel employee about why my entire AMD CPU family was excluded.
>  >
>  >  So why is this thing now in mainline with Ingo's sign-off and not a line
>  >  of changelog to explain it?
>  >
>  >
>  >
>  > >                     ^^^^^---- Here in Rene's patch...
>  > >
>  >
>  >  Yinghai's.
>  >
>  >
>  >
>  > > Wouldn't this be better if written the same as the Intel side, ie:
>  > > if (c->x86 >= 0xF && (c->x86 == 6 && c->x86_model == 7))
>  > > (or even with c->x86_model >= 7  ?)
>
>  i only can access opteron Rev E, Rev F, and Quad core. So i enabled that.
>
>  now, enable other one by one...

may add enable_pat command line, so other guys could test if their
cpus are ok with PAT...

YH
