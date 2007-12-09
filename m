Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbXLINQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbXLINQz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 08:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbXLINQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 08:16:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4819 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751095AbXLINQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 08:16:46 -0500
Date: Sun, 9 Dec 2007 13:16:36 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: David Rientjes <rientjes@google.com>,
       Kumar Gala <galak@kernel.crashing.org>, Olof Johansson <olof@lixom.net>,
       linuxppc-dev@ozlabs.org, magnus.damm@gmail.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fake NUMA emulation for PowerPC
Message-ID: <20071209131636.GF4381@ucw.cz>
References: <20071207211425.10223.91240.sendpatchset@balbir-laptop> <20071207212817.GA391@lixom.net> <4759BCA2.1020809@linux.vnet.ibm.com> <975B5B2B-C1F3-4021-9AE2-8873FFE1BDEC@kernel.crashing.org> <4759C548.6030304@linux.vnet.ibm.com> <alpine.DEB.0.9999.0712071508460.27689@chino.kir.corp.google.com> <475A1BEE.2050109@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475A1BEE.2050109@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat 2007-12-08 09:52:06, Balbir Singh wrote:
> David Rientjes wrote:
> > On Sat, 8 Dec 2007, Balbir Singh wrote:
> > 
> >> To be able to test the memory controller under NUMA, I use fake NUMA
> >> nodes. x86-64 has a similar feature, the code I have here is the
> >> simplest I could come up with for PowerPC.
> >>
> > 
> > Magnus Damm had patches from over a year ago that, I believe, made much of 
> > the x86_64 fake NUMA code generic so that it could be extended for 
> > architectures such as i386.  Perhaps he could resurrect those patches if 
> > there is wider interest in such a tool.
> 
> That would be a very interesting patch, but what I have here is the
> simplest patch and we could build on it incrementally. The interface is
> non-standard but it does amazing things for 59 lines of code change.

Well, maybe it is amazing, but having non-standard interface is also
wrong...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
