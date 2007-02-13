Return-Path: <linux-kernel-owner+w=401wt.eu-S1751198AbXBMIl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751198AbXBMIl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 03:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXBMIl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 03:41:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33077 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXBMIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 03:41:25 -0500
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Lameter <clameter@sgi.com>, Vojtech Pavlik <vojtech@suse.cz>,
       Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
In-Reply-To: <200702130928.05838.andi@firstfloor.org>
References: <20070201095952.589234000@jet.suse.cz>
	 <Pine.LNX.4.64.0702121632420.19380@schroedinger.engr.sgi.com>
	 <1171348808.12771.19.camel@laptopd505.fenrus.org>
	 <200702130928.05838.andi@firstfloor.org>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 09:41:17 +0100
Message-Id: <1171356078.12771.47.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-02-13 at 09:28 +0100, Andi Kleen wrote:
> On Tuesday 13 February 2007 07:40, Arjan van de Ven wrote:
> > On Mon, 2007-02-12 at 16:34 -0800, Christoph Lameter wrote:
> > > On Fri, 2 Feb 2007, Andi Kleen wrote:
> > > 
> > > > I've threatened to just disable RDTSC for ring 3 before, but it'll likely
> > > > never happen because too many programs use it.
> > > 
> > > Those programs are aware that they are fiddling around with low level 
> > > material but with this patchset we are going to have a non 
> > > monotonic time subsystem?
> > 
> > no quite the opposite. gettimeofday() currently is NOT monotonic
> > unfortunately. 
> 
> Anytime it is non monotonic that's a bug. We've had bugs
> like this before, but recently we're doing reasonably well. Of course
> there can be always improvements, but in general I don't agree
> with your statement, sorry. You can usually rely on it being monotonic,
> short of the known limitations (e.g. don't run ntpd) 

oh I agree it should be monotonic, but I remember an argument I had with
you several weeks ago where you were basically saying the opposite ;)

I'm happy to see gtod become more monotonic/reliable any way we can


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

