Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbZAYJlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbZAYJlM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 04:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZAYJk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 04:40:57 -0500
Received: from www.tglx.de ([62.245.132.106]:50081 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbZAYJk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 04:40:56 -0500
Date: Sun, 25 Jan 2009 10:40:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Theodore Tso <tytso@mit.edu>
cc: Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>, Lee Revell <rlrevell@joe-job.com>,
       linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RT] [RFC] simple SMI detector
In-Reply-To: <20090125040246.GE9216@mit.edu>
Message-ID: <alpine.LFD.2.00.0901251035050.3424@localhost.localdomain>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org> <75b66ecd0901231833j2fda4554sb0f47457ab838566@mail.gmail.com> <alpine.LFD.2.00.0901241716540.3424@localhost.localdomain> <1232845026.3990.71.camel@perihelion.bos.jonmasters.org>
 <1232849565.29318.112.camel@sven.thebigcorporation.com> <20090125040246.GE9216@mit.edu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009, Theodore Tso wrote:
> On Sun, Jan 25, 2009 at 01:12:45PM +1100, Sven-Thorsten Dietrich wrote:
> I will also note that for some applications (i.e., military hardware
> running under battle conditions), where it might be that running the
> hardware beyond its thermal limits might actually be *desirable*.
> After all, an extra 15 minutes of running beyond thermal limits that
> eventually causes the CPU to get flakey might be worth it if the
> alternative is the ship getting sunk because the BIOS decided that
> shutting down the CPU to save it from thermal damage was more
> important than say, running the anti-aircraft guns....

In that case the system designer knows exactly what he is doing and he
is aware of the consequences.

My concern about the SMI disable module is that it can damage Joe
users hardware. I have at least two reports where the CPU got fried
and some others where people got confused because chips started
behaving weird and it took quite a time to figure out that they used
the SMI disabler. A big fat warning about this code is definitely
necessary.

Thanks,

	tglx
