Return-Path: <linux-kernel-owner+w=401wt.eu-S1759757AbZF3W4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759757AbZF3W4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbZF3W4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:56:13 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:46181 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759410AbZF3W4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:56:09 -0400
Date: Tue, 30 Jun 2009 18:55:55 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       linux-arch@vger.kernel.org, andi@firstfloor.org, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCHSET] percpu: generalize first chunk allocators and improve
 lpage NUMA support
In-Reply-To: <20090630223138.GH1241@elte.hu>
Message-ID: <alpine.DEB.1.10.0906301847260.19482@gentwo.org>
References: <1245850216-31653-1-git-send-email-tj@kernel.org> <20090624165508.30b88343.akpm@linux-foundation.org> <alpine.DEB.1.10.0906291920100.32637@gentwo.org> <20090629163937.94c8cedd.akpm@linux-foundation.org> <20090630191517.GB20567@elte.hu>
 <alpine.DEB.1.10.0906301533400.29795@gentwo.org> <20090630213146.GA17492@elte.hu> <alpine.DEB.1.10.0906301809330.11362@gentwo.org> <20090630223138.GH1241@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009, Ingo Molnar wrote:

> The usecase i'm talking about is to boot a generic,
> many-CPUs-capable kernel in a guest image.

The many-cpu-capable kernel is not the issue. The number of potential cpus
is config information provided by the hardware. In your case the host
system provides the number of possible processors.

> How would you allow that guest to stay on 2 virtual CPUs but still
> be able to hot-plug many other CPUs if the guest context rises above
> its original CPU utilization?

The use case is a guest that needs to add a couple of thousand processors?

That will require lots of memory and special configuration of the guest
environment simulated. Yes that is an extreme case that will require lots
of per cpu memory.

