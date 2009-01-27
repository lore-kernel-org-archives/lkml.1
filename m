Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbZA0SBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbZA0SBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZA0SBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:01:04 -0500
Received: from vms173009pub.verizon.net ([206.46.173.9]:58149 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbZA0SBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:01:03 -0500
Date: Tue, 27 Jan 2009 13:00:42 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jon Masters <jcm@redhat.com>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>
Subject: Re: [RT] [RFC] simple SMI detector
In-reply-to: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
Message-id: <alpine.LFD.2.00.0901271249460.19655@localhost.localdomain>
References: <1232751312.3990.59.camel@perihelion.bos.jonmasters.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is it possible that if the detector is running,
it may prevent (delay) the thing it is trying to detect?

Eg. some random AML gets interpreted by the kernel,
it needs to touch an MSR, but MSRs are not accessible
from AML, so it triggeres an SMI by touching a magic IO address
with a magic value.

So in this case, the random AML may not run until after
the detector has stopped running, because the detector
prevented some random user-space distro value-add
from polling the battery or the temperature or something...

The other example that comes to mind is that dreaded
USB PS/2 emulation done via SMM.

FWIW I detest SMM as much as any OS person should.
But I also acknowledge that it is virtually impossible to prevent
BIOS developers from giving it up.  We OS types have proposed an
"SMI has happened bit or counter" many times,
even though we'd rather have a "SMM disable" bit:-)

cheers,
--
Len Brown, Intel Open Source Technology Center
