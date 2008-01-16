Return-Path: <linux-kernel-owner+w=401wt.eu-S1752052AbYAPRlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052AbYAPRlE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:41:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbYAPRky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:40:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbYAPRkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:40:53 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] x86: some more patches
Date: Wed, 16 Jan 2008 18:40:44 +0100
User-Agent: KMail/1.9.6
Cc: Jan Beulich <jbeulich@novell.com>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <patchbomb.1200435425@localhost> <478E3411.76E4.0078.0@novell.com> <20080116154710.GA28946@elte.hu>
In-Reply-To: <20080116154710.GA28946@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801161840.44683.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



git-x86 upto a9f7faa5fd229a65747f02ab0f2d45ee35856760 boots, but gives

VFS: Mounted root (nfs filesystem).
Freeing unused kernel memory: 264k freed
eth0: no IPv6 routers present
Clocksource tsc unstable (delta = 18747555652 ns)

BUG: soft lockup - CPU#2 stuck for 55s! [swapper:0]

Pid: 0, comm: swapper Not tainted (2.6.24-rc8-ga9f7faa5 #23)
EIP: 0060:[<c0103b71>] EFLAGS: 00000206 CPU: 2
EIP is at default_idle+0x36/0x58
EAX: 6f179d4d EBX: 6f179d4d ECX: 000001c9 EDX: 0000006a
ESI: 0000006a EDI: 00000000 EBP: 00000000 ESP: f7c49fa4
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
CR0: 8005003b CR2: bfaaf990 CR3: 3749f000 CR4: 000006f0
DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
DR6: ffff0ff0 DR7: 00000400
 [<c0103b3b>] default_idle+0x0/0x58
 [<c0103a7e>] cpu_idle+0xad/0xcd
 =======================

-Andi
