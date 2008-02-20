Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbYBTVr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbYBTVr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757421AbYBTVrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:47:20 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:10132 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbYBTVrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:47:18 -0500
Date: Wed, 20 Feb 2008 13:42:17 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080220214217.GA28444@mail.oracle.com>
Mail-Followup-To: Ian Campbell <ijc@hellion.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mika Penttila <mika.penttila@kolumbus.fi>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org> <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org> <20080215202336.GE26034@mail.oracle.com> <1203274161.27987.6.camel@localhost.localdomain> <20080218104025.GA15899@ca-server1.us.oracle.com> <1203458366.26910.15.camel@cthulhu.hellion.org.uk> <47BBDA20.8030105@zytor.com> <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 08:51:50AM +0000, Ian Campbell wrote:
> 
> On Tue, 2008-02-19 at 23:43 -0800, H. Peter Anvin wrote:
> > NAK!
> 
> As far as the actual change goes I was assuming that any machine that
> has DMI/SMBIOS would easily be new enough to have an E820 which could be
> expected to reserve this region. Looks like I was mistaken about how
> long E820 had been around and/or how reliably it is used to reserve the
> tables.
> 
> Anyway, will have to think of another solution.

	What changed to make this not work in the first place?  New dmi
code?

Joel

-- 

"The real reason GNU ls is 8-bit-clean is so that they can
 start using ISO-8859-1 option characters."
	- Christopher Davis (ckd@loiosh.kei.com)

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
