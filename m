Return-Path: <linux-kernel-owner+w=401wt.eu-S1753115AbZBNRhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115AbZBNRhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 12:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbZBNRhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 12:37:05 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:62795 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbZBNRhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 12:37:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HWcfipIsQ2wkX1+KXD+p96IDVTTJUymDXcx5UWs9CmMfh48Mon6HfsGiQ3cIPuN5aS
         Ooui3MlKjrxd0NgAVSJJKUaFfg3t5cGeHOaCNlBT/3MW5rO/wlfqNt2ZSiwxdVmT9vAO
         Sw08U3KVR0oqyYPoWLrGavZCQYNdFk4gDkqd0=
MIME-Version: 1.0
In-Reply-To: <20090214150622.GF7194@linux.vnet.ibm.com>
References: <20090213155507.GA2838@Krystal> <20090213173352.GB4684@Krystal>
	 <alpine.LFD.2.00.0902130945350.3179@localhost.localdomain>
	 <alpine.LFD.2.00.0902130956400.3179@localhost.localdomain>
	 <20090213185411.GB7124@Krystal>
	 <20090213193619.GH6854@linux.vnet.ibm.com>
	 <8bd0f97a0902132107r3651ce4rc5bc4e027268e2aa@mail.gmail.com>
	 <20090214052030.GB7194@linux.vnet.ibm.com>
	 <8bd0f97a0902132146t2badab79ue76e0a43d74c95ca@mail.gmail.com>
	 <20090214150622.GF7194@linux.vnet.ibm.com>
Date: Sat, 14 Feb 2009 12:37:01 -0500
Message-ID: <8bd0f97a0902140937v22917306m44e062d5b0dfacf6@mail.gmail.com>
Subject: Re: [ltt-dev] [RFC git tree] Userspace RCU (urcu) for Linux (repost)
From: Mike Frysinger <vapier.adi@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Bryan Wu <cooloney@kernel.org>,
       linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 14, 2009 at 10:06, Paul E. McKenney wrote:
> Other potential issues include unrelated processes that share memory via
> shmget() or mmap() -- presumably groups of such processes would need to
> be bound to a single CPU?

using PROT_WRITE with MAP_SHARED is a mess with no-mmu already ... in
other words, it isnt in use in practice as most of the time, the
kernel wont even grant it

i dont believe we've looked at shm/ipc ... i'll open a tracker item on
our side to review it
-mike
