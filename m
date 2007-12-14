Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbXLNLxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbXLNLxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 06:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713AbXLNLw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 06:52:59 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:38770 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXLNLw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 06:52:58 -0500
Subject: Re: Possible issue with dangling PCI BARs
From: Jon Masters <jonathan@jonmasters.org>
To: benh@kernel.crashing.org
Cc: linux-pci@atrey.karlin.mff.cuni.cz,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1197514804.15741.60.camel@pasglop>
References: <1197514804.15741.60.camel@pasglop>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Fri, 14 Dec 2007 06:52:11 -0500
Message-Id: <1197633131.29507.97.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2007-12-13 at 14:00 +1100, Benjamin Herrenschmidt wrote:
> While reworking the powerpc PCI resource management, to make it more
> x86-like and use more of the generic code in setup-bus.c and
> setup-res.c, I noticed something a bit fishy in the way we deal with
> resources that we failed to assign.

On a tangent here, is there a way (other than pci=rom) to ensure greater
address space/resource space for PCI resource mappings?

Jon.


