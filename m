Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYAOQcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYAOQcz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 11:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbYAOQcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 11:32:47 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:47393 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751484AbYAOQcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 11:32:46 -0500
Date: Tue, 15 Jan 2008 11:32:46 -0500
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Tuomo Valkonen <tuomov@iki.fi>, linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
Message-ID: <20080115163246.GE2308@csclub.uwaterloo.ca>
References: <20080113222310.GA20815@jolt.modeemi.cs.tut.fi> <20080113231150.GB23906@mit.edu> <20080114071555.GA6475@jolt.modeemi.cs.tut.fi> <1200303743.24517.6.camel@tara.firmix.at> <slrnfombug.lco.tuomov@jolt.modeemi.cs.tut.fi> <m3d4s4yb4s.fsf@maximus.localdomain> <20080114110328.GA29126@jolt.modeemi.cs.tut.fi> <m3myr8vakf.fsf@maximus.localdomain> <20080114161828.GO2310@csclub.uwaterloo.ca> <m3bq7nao9d.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3bq7nao9d.fsf@maximus.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2008 at 02:09:02AM +0100, Krzysztof Halasa wrote:
> Right, I remember some reports about that, probably IOAPIC or other
> HPET issues. Personally never seen that. Thus the suggestion of kernel
> upgrade.

I believe the ATI chipset managed to somehow get the timer interrupt to
arive both on the legacy 8259 and the APIC causing each timer tick to
count twice.  Nice way to double your system time rate.  The nforce2
didn't double, it just ran fast some of the time, which I have no idea
how happened, but it went away with newer kernels (and wasn't there with
earlier kernels either).

--
Len Sorensen
