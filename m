Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZG1JVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZG1JVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 05:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZG1JVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 05:21:31 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34488 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZG1JVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 05:21:30 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Morris <jmorris@namei.org>, James Carter <jwcart2@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       Stephen Smalley <sds@tycho.nsa.gov>, spender@grsecurity.net,
       Daniel J Walsh <dwalsh@redhat.com>, cl@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>, kees@outflux.net,
       Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
From: Andi Kleen <andi@firstfloor.org>
References: <1248132223.2654.278.camel@localhost>
	<alpine.LRH.2.00.0907211258110.32400@tundra.namei.org>
	<1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil>
	<alpine.LRH.2.00.0907221953190.15799@tundra.namei.org>
	<20090728011943.589176cb@lxorguk.ukuu.org.uk>
Date: Tue, 28 Jul 2009 11:21:29 +0200
In-Reply-To: <20090728011943.589176cb@lxorguk.ukuu.org.uk> (Alan Cox's message of "Tue, 28 Jul 2009 01:19:43 +0100")
Message-ID: <87zlapgo2u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> A dumb question perhaps, but while addling my brain over the tty layer I
> was wondering if for the specific case of jump through NULL (which seems
> to be the most common but by no means only problem case that gets
> exploited) is there any reason we can't set a default breakpoint for

You mean a hardware breakpoint? Hardware break points are a precious
scarce resource. The people who rely on them would be likely
unhappy if you take one way from them.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
