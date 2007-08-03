Return-Path: <linux-kernel-owner+w=401wt.eu-S1763319AbXHCP6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763319AbXHCP6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbXHCP6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:58:43 -0400
Received: from adelie.ubuntu.com ([82.211.81.139]:39663 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbXHCP6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:58:42 -0400
Subject: Re: Regression in 2.6.22, clock problems on Turion with 32-bit
	kernel
From: Ben Collins <ben.collins@ubuntu.com>
To: Cal Peake <cp@absolutedigital.net>
Cc: Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Tim Gardner <tim.gardner@canonical.com>
In-Reply-To: <Pine.LNX.4.64.0708031146090.3978@lancer.cnet.absolutedigital.net>
References: <1186150484.8105.57.camel@cunning>
	 <1186155056.2707.0.camel@laptopd505.fenrus.org>
	 <1186155828.8105.69.camel@cunning>
	 <Pine.LNX.4.64.0708031146090.3978@lancer.cnet.absolutedigital.net>
Content-Type: text/plain
Organization: Canonical
Date: Fri, 03 Aug 2007 11:58:33 -0400
Message-Id: <1186156713.8105.76.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.5 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-08-03 at 11:50 -0400, Cal Peake wrote:
> On Fri, 3 Aug 2007, Ben Collins wrote:
> 
> > 
> > On Fri, 2007-08-03 at 08:30 -0700, Arjan van de Ven wrote:
> > > > I've tried every combination of boot param revolving around clocksource
> > > > and interrupts. The only thing that gets me booting is nolapic, but then
> > > > again, that knocks me down to a single cpu. 
> > > 
> > > hummm.... I wonder how nolapic knows you down to a single cpu.......
> > > that is just an entirely strange relationship.
> > 
> > Sorry, s/cpu/core/, but not sure if that makes a difference.
> 
> Ben, Tim,
> 
> See thread <http://marc.info/?t=118573271600006&r=1&w=2>. Short version: 
> nolapic_timer should fix things for the moment. Long term: some AMD kernel 
> code needs to be fixed up to deal with a broken local APIC.


nolapic_timer does not fix it for me. Only nolapic and acpi=off works. I
commented on that thread as well now, thanks.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

