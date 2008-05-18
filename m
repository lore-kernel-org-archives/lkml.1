Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYERLDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYERLDU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 07:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYERLDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 07:03:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:52218 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750951AbYERLDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 07:03:11 -0400
X-Authenticated: #428038
X-Provags-ID: V01U2FsdGVkX1+y0qdnJRSySiEG+ajnf6L5N5X7bPuX1LwAafcaTQ
	Kw7Gxx1iFZAR+W
Date: Sun, 18 May 2008 13:03:06 +0200
From: Matthias Andree <matthias.andree@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net: remove network drivers' last few uses of
	IRQF_SAMPLE_RANDOM
Message-ID: <20080518110306.GD9845@merlin.emma.line.org>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com> <20080515142154.0595e475@core> <36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com> <20080515215517.GI1936@cs181133002.pp.htv.fi> <1211070968.18026.113.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1211070968.18026.113.camel@calx>
X-PGP-Key: http://home.pages.de/~mandree/keys/GPGKEY.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 May 2008, Matt Mackall wrote:

> It certainly makes sense to sample network timing noise. It often does
> not make sense to assume that there's any entropy in those timing
> samples. For instance:
> 
> - our clock resolution may be low enough that an attacker can guess our
> samples (ie it's simply HZ, very common in embedded land)
> - the bus involved (ISA, peripheral bus, even slow PCI) may have the
> same issue
> - it may be heavily correlated with some other measurement (ie network
> vs disk samples on file servers)
> 
> We currently assume that IRQF_SAMPLE_RANDOM means 'this is a completely
> trusted unobservable entropy source' which is obviously wrong for
> network devices but is right for some other classes of device.

Without looking at code, should your summary should include
"independent of (as in non-correlated with) other sources" according to
your argument?

-- 
Matthias Andree
