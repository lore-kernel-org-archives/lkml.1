Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbYJXXS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbYJXXS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbYJXXSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:18:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55487
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754612AbYJXXSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:18:40 -0400
Date: Fri, 24 Oct 2008 16:18:18 -0700 (PDT)
Message-Id: <20081024.161818.256978293.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: csnook@redhat.com, maxk@qualcomm.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: default IRQ affinity change in v2.6.27 (breaking several SMP
 PPC based systems)
From: David Miller <davem@davemloft.net>
In-Reply-To: <36A821E7-7F37-42AF-9A05-7205FCBF89EE@kernel.crashing.org>
References: <4E3CD4D5-FC1B-40BF-A776-C612B95806B8@kernel.crashing.org>
	<4901E6FB.4070200@redhat.com>
	<36A821E7-7F37-42AF-9A05-7205FCBF89EE@kernel.crashing.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Fri, 24 Oct 2008 10:39:05 -0500

> As for making it ARCH specific, that doesn't really help since not
> all PPC hw has the limitation I spoke of.  Not even all MPIC (in our
> cases) have the limitation.

Since the PPC code knows exactly which MPICs have the problem the
PPC code is where the constraining can occur.

I agree completely with the suggestion that the arch code has to
interpret the cpumask as appropriate for the hardware, since the
user can stick "illegal" values there anyways.
