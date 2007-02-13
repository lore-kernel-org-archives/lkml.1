Return-Path: <linux-kernel-owner+w=401wt.eu-S1030598AbXBMAek@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030598AbXBMAek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 19:34:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030599AbXBMAek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 19:34:40 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:39657 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030598AbXBMAej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 19:34:39 -0500
Date: Mon, 12 Feb 2007 16:34:07 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Andi Kleen <ak@suse.de>
cc: Vojtech Pavlik <vojtech@suse.cz>, Jiri Bohac <jbohac@suse.cz>,
       linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, arjan@infradead.org,
       tglx@linutronix.de, johnstul@us.ibm.com, zippel@linux-m68k.org,
       andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
In-Reply-To: <200702020814.27378.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0702121632420.19380@schroedinger.engr.sgi.com>
References: <20070201095952.589234000@jet.suse.cz> <20070201131715.GM21755@dwarf.suse.cz>
 <20070201151654.GA20385@suse.cz> <200702020814.27378.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Andi Kleen wrote:

> I've threatened to just disable RDTSC for ring 3 before, but it'll likely
> never happen because too many programs use it.

Those programs are aware that they are fiddling around with low level 
material but with this patchset we are going to have a non 
monotonic time subsystem? Programs expects gettimeofday() etc to be 
monotonic. Its going to a big surprise if that is not working anymore.

