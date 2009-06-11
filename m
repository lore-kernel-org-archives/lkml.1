Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbZFKNS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbZFKNS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZFKNSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:18:21 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26255 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbZFKNSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:18:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=IKxzlU2BpcNJSuVVcGxVfHohLg8AQcsyjTsrpV78i+gacrfg8a1IIWviwbaP6XWN7
	1TY5/Tiut55Fc3xLoXgVw==
MIME-Version: 1.0
In-Reply-To: <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
	 <20090611.042226.28424489.davem@davemloft.net>
	 <20090611114911.GL795@n2100.arm.linux.org.uk>
	 <20090611.050030.169859977.davem@davemloft.net>
	 <20090611123852.GM795@n2100.arm.linux.org.uk>
	 <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
Date: Thu, 11 Jun 2009 06:18:15 -0700
Message-ID: <a55d774e0906110618k20cdccd5wd1655e5c3dbef6ec@mail.gmail.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
From: Brian Swetland <swetland@google.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, pavel@ucw.cz,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 5:54 AM, Alan Cox<alan@lxorguk.ukuu.org.uk> wrote:
>
> Make your tree the core ARM code only, any other patches you don't
> accept. Aggressively push stuff out to platform code, and if people want
> to change core code "because our platform is different" make them extract
> it into the platform layer not carry it in the core bits.
>
> Nominate a bunch of people for the main ARM platforms. What they put into
> their platform specific trees goes direct from them to -next and if they
> trash their own platform thats their problem (and they can come to you
> for advice ;))
>
> Leave it to the platform people to push their driver code through the
> right channels.

This would seem to address a lot of the scalability issues, and from
what I can tell, it's pretty hard for somebody mucking stuff up in
arch/arm/mach-something/... to break arch/arm/mach-otherthing/...

I'd be thrilled to get the msm stuff in to the main tree and deal with
patches submitted against it (and the android stuff in staging seems
to show that people will start submitting patches against things if
it's in the mainline -- for example the binder patches that have
turned up, etc).

As far as what we're maintaining in the android-msm tree, there's:
generic android drivers -- most of which are already in staging thanks to Greg
arch/arm/mach-msm/... -- 7k (and soon 8k) SoC support
various msm drivers -- could be submitted via drivers/staging and the
usual review process
a couple small generic arm patches -- stuff that we should be
discussing in lakml
some generic linux patches -- Arve's pretty good about sending these
to lkml as they happen

Brian
