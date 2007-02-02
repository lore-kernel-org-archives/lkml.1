Return-Path: <linux-kernel-owner+w=401wt.eu-S1423171AbXBBHV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423171AbXBBHV3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 02:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423177AbXBBHV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 02:21:29 -0500
Received: from ns.suse.de ([195.135.220.2]:44754 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423172AbXBBHV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 02:21:27 -0500
From: Andi Kleen <ak@suse.de>
To: Vojtech Pavlik <vojtech@suse.cz>
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Date: Fri, 2 Feb 2007 08:14:27 +0100
User-Agent: KMail/1.9.5
Cc: Jiri Bohac <jbohac@suse.cz>, linux-kernel@vger.kernel.org,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201131715.GM21755@dwarf.suse.cz> <20070201151654.GA20385@suse.cz>
In-Reply-To: <20070201151654.GA20385@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702020814.27378.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 16:16, Vojtech Pavlik wrote:

> It might even make sense to desycnhronize the TSCs on such (AMD)
> machines on purpose, so that applications that rely on TSC break
> immediately and not after some time when the error becomes too large.

They won't because they're normally single threaded (and most people
still use single core systems anyways) 

I've threatened to just disable RDTSC for ring 3 before, but it'll likely
never happen because too many programs use it.

-Andi
