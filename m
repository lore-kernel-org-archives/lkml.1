Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbYBRVHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbYBRVHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 16:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762387AbYBRVGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 16:06:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:55465 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762958AbYBRVGg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 16:06:36 -0500
Subject: Re: [Patch 0/2] powerpc: avoid userspace poking to legacy ioports
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Jean Delvare <khali@linux-fr.org>
Cc: Christian Krafft <krafft@de.ibm.com>, linux-kernel@vger.kernel.org,
       parabelboi@bopserverein.de, linuxppc-dev@ozlabs.org
In-Reply-To: <20080218215842.66bb004f@hyperion.delvare>
References: <20080213182800.5c6940a8@de.ibm.com>
	 <20080213183506.7f3e3145@de.ibm.com> <1202935374.7296.44.camel@pasglop>
	 <20080218211519.2b159ade@hyperion.delvare>
	 <1203367323.6740.21.camel@pasglop>
	 <20080218215842.66bb004f@hyperion.delvare>
Content-Type: text/plain
Date: Tue, 19 Feb 2008 08:05:16 +1100
Message-Id: <1203368716.6740.24.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> * Super-I/O chips at 0x2e/0x2f and 0x4e/0x4f.
> 
> * Legacy PC hardware monitoring chips at 0x290-0x297.
> 
> * IPMI interface at 0x0ca3 and 0x0cab (read-only).
> 
> Please tell me which ones should be skipped on PowerPC.

Skip the whole thing. I consider that on a powerpc linux port, the
platform is responsible for telling drivers where things are (via the
device tree generally)
 
> Christian, can you tell me which of these probes caused trouble for you?
> 
> > > And how is userland code poking at random ports different from kernel
> > > code poking at random ports? We could move sensors-detect inside the
> > > kernel (and I have some plan to do that) but I fail to see how this
> > > would solve this particular problem.
> > 
> > It wouldn't, but at least I could NAK it or make it CONFIG_X86 :-)
> 
> The same could be done for user-space (or at the /dev/port level.)

Well, there are -other- legit usages of /dev/port...

Ben.


