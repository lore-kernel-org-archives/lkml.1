Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab0BDT7k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:59:40 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:42078 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932879Ab0BDT7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:59:38 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WEKsV8UmmsBQ+YWaPqbijb/O9gPmGKmE07f/aYVXBCaYTl+izB2gQ1qZIEpUjDTk1rWLExTSIn5WLOPzQMz/zddVC169MagKw3zngfFUDjBV/C2W7VczRASxBGkTBpOq;
Date: Thu, 4 Feb 2010 11:53:16 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Dave Airlie <airlied@linux.ie>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Subject: Re: hung bootup with "drm/radeon/kms: move radeon KMS on/off switch
 out of staging."
Message-ID: <20100204115316.69beee75@jbarnes-piketon>
In-Reply-To: <20100204193232.GD6665@elte.hu>
References: <20100204071705.GA28403@elte.hu>
	<20100204164859.GA17878@srcf.ucam.org>
	<20100204170826.GA16397@elte.hu>
	<20100204173602.GA19855@srcf.ucam.org>
	<20100204175445.GB27361@elte.hu>
	<20100204175928.GA20595@srcf.ucam.org>
	<20100204181218.GA6175@elte.hu>
	<a728f9f91002041030o7c8d38edxe573bc0a1327d79@mail.gmail.com>
	<20100204190649.GB6665@elte.hu>
	<a728f9f91002041118m6415844fp1740f18fdc1c9757@mail.gmail.com>
	<20100204193232.GD6665@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 20:32:32 +0100
Ingo Molnar <mingo@elte.hu> wrote:
> Nobody has reacted to my related boot hang bugreport yet - and it's
> detailed and fully reproducible (so i can test any proposed fixes as
> well in short order). I.e. my limited testing has triggered two
> separate bugs in the same driver - and this will show up in -rc7.
> 
> It might be all OK and no-one else will see trouble. Or past patterns
> might repeat themselves and i might simply be an early bird for
> trouble to come.
> 
> My (oft repeated) point is that adding new sub-features to existing
> drivers is not what we do in late -rc's: there's simply not enough
> time to shake out bugs/regressions in them.
> 
> We introduce new functionality to existing drivers in the merge
> window - in the two weeks following a stable kernel's release.

This is the .config issue right?  It doesn't sound like the bug is new,
you're just seeing now it because of the way you run tests.  It
shouldn't affect any more or fewer users than it did before, and
reverting the "move radeon KMS out of staging" won't fix the bug at all
or prevent anyone from seeing it.  People using KMS will still use KMS
and people without it won't, because no one actually uses allyes
configs, and the option defaults to N anyway.

> In late -rc's we only try to fix regressions. Sometimes we make
> exceptions for pragmatic reasons, but then we are straightforward
> about those reasons and try to warn users about our zeal to help them
> with cool, new, not-to-be-missed GPU functionality ;-)

Agree, I just don't think this is a regression or an exception.

-- 
Jesse Barnes, Intel Open Source Technology Center
