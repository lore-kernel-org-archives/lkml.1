Return-Path: <linux-kernel-owner+w=401wt.eu-S1750918AbXBMRKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750918AbXBMRKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 12:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750921AbXBMRKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 12:10:13 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:60102 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750918AbXBMRKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 12:10:12 -0500
Date: Tue, 13 Feb 2007 09:09:13 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Arjan van de Ven <arjan@infradead.org>
cc: Andi Kleen <ak@suse.de>, Vojtech Pavlik <vojtech@suse.cz>,
       Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, tglx@linutronix.de, johnstul@us.ibm.com,
       zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
In-Reply-To: <1171348808.12771.19.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com>
References: <20070201095952.589234000@jet.suse.cz>  <20070201131715.GM21755@dwarf.suse.cz>
 <20070201151654.GA20385@suse.cz>  <200702020814.27378.ak@suse.de> 
 <Pine.LNX.4.64.0702121632420.19380@schroedinger.engr.sgi.com>
 <1171348808.12771.19.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Feb 2007, Arjan van de Ven wrote:

> no quite the opposite. gettimeofday() currently is NOT monotonic
> unfortunately. With this patchseries it actually has a better chance of
> becoming that...

It is monotonic on IA64 at least and we have found that subtle application 
bugs occur if it is not. IA64 (and other arches using time interpolation) 
can insure the monotoneity of time sources. Are you sure about this? I 
wonder why the new time of day subsystem does not have that?
