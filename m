Return-Path: <linux-kernel-owner+w=401wt.eu-S1754850AbZG1QX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850AbZG1QX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 12:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbZG1QXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 12:23:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59348 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831AbZG1QXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 12:23:55 -0400
Date: Tue, 28 Jul 2009 18:23:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees@ubuntu.com>
Cc: Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Morris <jmorris@namei.org>, James Carter <jwcart2@tycho.nsa.gov>,
       Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov,
       Stephen Smalley <sds@tycho.nsa.gov>, spender@grsecurity.net,
       Daniel J Walsh <dwalsh@redhat.com>, cl@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, mingo@elte.hu
Subject: Re: mmap_min_addr and your local LSM (ok, just SELinux)
Message-ID: <20090728162353.GO15310@basil.fritz.box>
References: <1248132223.2654.278.camel@localhost> <alpine.LRH.2.00.0907211258110.32400@tundra.namei.org> <1248187482.19456.90.camel@moss-lions.epoch.ncsc.mil> <alpine.LRH.2.00.0907221953190.15799@tundra.namei.org> <20090728011943.589176cb@lxorguk.ukuu.org.uk> <87zlapgo2u.fsf@basil.nowhere.org> <20090728155622.GO7316@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728155622.GO7316@outflux.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could the page table flags be used to mask this region?  i.e. force
> PROT_NONE (with the "desired" flags stored elsewhere) and in the segv
> handler check if it is kernel or user space, and then fix-up the flags and
> continue if it's userspace?  (I really don't know the internals on this,
> but it would need to restore PROT_NONE on task-switch or something...)

That's racy with multiple threads.
-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
