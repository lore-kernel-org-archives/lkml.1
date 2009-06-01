Return-Path: <linux-kernel-owner+w=401wt.eu-S1752872AbZFAS6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbZFAS6e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 14:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZFAS60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 14:58:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56030 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZFAS6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 14:58:25 -0400
Message-ID: <4A24248E.3060005@zytor.com>
Date: Mon, 01 Jun 2009 11:57:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Borislav Petkov <petkovbb@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <borislav.petkov@amd.com>, greg@kroah.com,
       mingo@elte.hu, norsk5@yahoo.com, tglx@linutronix.de, mchehab@redhat.com,
       aris@redhat.com, edt@aei.ca, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 0/4] amd64_edac: misc fixes
References: <1242845037-1029-1-git-send-email-borislav.petkov@amd.com> <20090528164720.0af5752b.akpm@linux-foundation.org> <20090529103329.GB23530@aftab> <20090529130115.a44efaee.akpm@linux-foundation.org> <20090530081954.GA21954@liondog.tnic> <20090530014007.3c1e22d5.akpm@linux-foundation.org> <4A218761.5080607@zytor.com> <20090601145326.GA28260@liondog.tnic> <4A2407D1.5050706@zytor.com> <20090601181208.GA30565@liondog.tnic>
In-Reply-To: <20090601181208.GA30565@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Borislav Petkov wrote:
> Actually, popcnt got added to gas in July 2006 so checking the gas
> version should suffice, IMHO.

gas is part of binutils.

> Anyway, I proposed something similar before but Andrew suggested that we
> should simply slap in the opcode so we don't need the Kbuild changes.
> The advantage of the approach is that it works unconditionally on all
> toolchains and introduces less code changes. Hmm...

That really sucks, though, in the long run.  I personally prefer to have
the "right thing" -- which in this case is probably gcc intrinsics --
and then a fallback that will gradually fall out of use.

	-hpa

