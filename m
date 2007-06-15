Return-Path: <linux-kernel-owner+w=401wt.eu-S1756312AbXFONVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312AbXFONVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:21:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753273AbXFONVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:21:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:55002 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbXFONVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:21:23 -0400
Subject: Re: [PATCH] Introduce compat_u64 and compat_s64 types
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Andi Kleen <ak@suse.de>
Cc: Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@linux.ie>, linux-arch@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200706151440.10273.ak@suse.de>
References: <200706150159.l5F1xNgM000459@hera.kernel.org>
	 <200706151355.57464.ak@suse.de> <200706151403.53855.arnd@arndb.de>
	 <200706151440.10273.ak@suse.de>
Content-Type: text/plain
Date: Fri, 15 Jun 2007 23:19:43 +1000
Message-Id: <1181913584.26853.78.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 14:40 +0200, Andi Kleen wrote:
> > That is broken on all non-x86 architectures, 
> 
> It cannot be broken, it just might be somewhat slower

It is because there is already code out there that expects the padding
(32 bits userland code that is).

Ben.


