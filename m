Return-Path: <linux-kernel-owner+w=401wt.eu-S1161021AbXBMGkd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161021AbXBMGkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 01:40:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161026AbXBMGkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 01:40:33 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55863 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161021AbXBMGkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 01:40:32 -0500
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <ak@suse.de>, Vojtech Pavlik <vojtech@suse.cz>,
       Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
In-Reply-To: <Pine.LNX.4.64.0702121632420.19380@schroedinger.engr.sgi.com>
References: <20070201095952.589234000@jet.suse.cz>
	 <20070201131715.GM21755@dwarf.suse.cz> <20070201151654.GA20385@suse.cz>
	 <200702020814.27378.ak@suse.de>
	 <Pine.LNX.4.64.0702121632420.19380@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 13 Feb 2007 07:40:08 +0100
Message-Id: <1171348808.12771.19.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-12 at 16:34 -0800, Christoph Lameter wrote:
> On Fri, 2 Feb 2007, Andi Kleen wrote:
> 
> > I've threatened to just disable RDTSC for ring 3 before, but it'll likely
> > never happen because too many programs use it.
> 
> Those programs are aware that they are fiddling around with low level 
> material but with this patchset we are going to have a non 
> monotonic time subsystem?

no quite the opposite. gettimeofday() currently is NOT monotonic
unfortunately. With this patchseries it actually has a better chance of
becoming that...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

