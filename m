Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbYBTWax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbYBTWax (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 17:30:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760363AbYBTWal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 17:30:41 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:32417 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbYBTWaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 17:30:39 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <20080220214217.GA28444@mail.oracle.com>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	 <47BBDA20.8030105@zytor.com>
	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	 <20080220214217.GA28444@mail.oracle.com>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 22:30:24 +0000
Message-Id: <1203546624.26910.76.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=9-ZTVD01u88E_thCqbwA:9 a=oeWKJJoTUhYdRMV3SjgrVajD38EA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-02-20 at 13:42 -0800, Joel Becker wrote:
> 	What changed to make this not work in the first place?  New dmi
> code?

I don't think so -- this code is present even in the 2.6.18-xen.hg tree
(where it's gated with is_initial_domain() which isn't suitable for the
upstream tree).

I don't really know why it should start happening now. It may be that
some of the recentish changes to e.g. early_ioremap or early pagetable
setup etc. have tweaked the layout of the early pagetables around so
this problem bites us more readily. Or it may just be a combination of
kernel image size, RAM size and perhaps a dose of bad luck.

Ian.
-- 
Ian Campbell

... at least I thought I was dancing, 'til somebody stepped on my hand.
		-- J. B. White

