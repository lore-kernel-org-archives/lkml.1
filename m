Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbZF3Tke@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbZF3Tke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:40:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZF3Tk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:40:26 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46869 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752612AbZF3TkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:40:25 -0400
Date: Tue, 30 Jun 2009 15:39:52 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
In-Reply-To: <20090630191517.GB20567@elte.hu>
Message-ID: <alpine.DEB.1.10.0906301533400.29795@gentwo.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jun 2009, Ingo Molnar wrote:

> Yeah, it's a bug for something like a virtual environment which
> boots generic kernels that might have 64 possible CPUs (on a true
> 64-way system), but which will have fewer in practice.

A machine (and a virtual environment) can indicate via the BIOS tables or
ACPI that there are less "possible" cpus. That is actually very common.

The difference between actual and possible cpus only has to be the number
of processors that could be brought up later. In a regular system that is
pretty much zero. In a fancy system with actual hotpluggable cpus there
would be a difference but usually the number of hotpluggable cpus is
minimal.

