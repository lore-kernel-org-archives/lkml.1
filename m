Return-Path: <linux-kernel-owner+w=401wt.eu-S1759355AbZBEULQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355AbZBEULQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 15:11:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZBEUK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 15:10:59 -0500
Received: from one.firstfloor.org ([213.235.205.2]:38079 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZBEUK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 15:10:59 -0500
Date: Thu, 5 Feb 2009 21:27:30 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tim Pepper <tpepper@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Genapic cleanup & NUMAQ/es7000 removal
Message-ID: <20090205202730.GJ14832@one.firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org> <eada2a070902050815h6ba682e2u158c4bb7c32f89ef@mail.gmail.com> <20090205172941.GA24599@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205172941.GA24599@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not going to apply that series for the reasons i outlined in the NUMAQ 
> discussion already. The runtime callbacks arent really a maintenance 
> problem: most of them are in boot code so it's not a runtime overhead issue.

Ok.  It's basically dead code now, dropping it would just make
the kernels a little smaller and also the code somewhat easier
to read.

If you keep them I would be interested in hearing about your testing plan 
for es7000 and NUMAQ AFAIK there is noone currently running them which
makes that likely challenging.

Also the first two patches in the series were independent cleanups
not directly related and should be applied anyways independent
whether unused code should be dropped or not.

commit fa9b9131b555b1d72d6bbfa8c1d6cb22659cc011

    Remove empty setup_portio_remap inlines in bigsmp/summit

    These are all unused inlines

commit 47e05d047c0e9c5c75003ec7ce97de753b264ed6

    Move wakeup_secondary_via_nmi into numaq_32.c

    It's only used there.

-Andi
