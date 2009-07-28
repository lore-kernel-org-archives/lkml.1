Return-Path: <linux-kernel-owner+w=401wt.eu-S1753079AbZG1OtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbZG1OtA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 10:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751275AbZG1OtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 10:49:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47162 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZG1Os7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 10:48:59 -0400
Date: Tue, 28 Jul 2009 16:48:54 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Brad Spengler <spender@grsecurity.net>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Morris <jmorris@namei.org>, James Carter <jwcart2@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       cl@linux-foundation.org, Arjan van de Ven <arjan@infradead.org>,
       kees@outflux.net, Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090728144854.GN15310@basil.fritz.box>
References: <1248132223.2654.278.camel@localhost> <alpine.LRH.2.00.0907211258110.32400@tundra.namei.org> <1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil> <alpine.LRH.2.00.0907221953190.15799@tundra.namei.org> <20090728011943.589176cb@lxorguk.ukuu.org.uk> <87zlapgo2u.fsf@basil.nowhere.org> <20090728110028.31fa9a6f@lxorguk.ukuu.org.uk> <20090728112137.GF15310@basil.fritz.box> <20090728133547.GA23858@grsecurity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728133547.GA23858@grsecurity.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 09:35:47AM -0400, Brad Spengler wrote:
> > If you use all available break points (making all gdb users unhappy)
> > then you could still only cover 64 bytes on 64bit, 32 on 32bit.
> 
> Might want to double-check that math I think ;)

Good catch. I was off by one bit. It's 32 / 16.
Doesn't change the result I would guess though.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
