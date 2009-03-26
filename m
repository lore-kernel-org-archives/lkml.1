Return-Path: <linux-kernel-owner+w=401wt.eu-S1755780AbZCZADN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780AbZCZADN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 20:03:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZCZAC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 20:02:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:48180 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbZCZAC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 20:02:56 -0400
Subject: Re: [PATCH 04/57] microblaze_v7: Open firmware files
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: avorontsov@ru.mvista.com
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, john.williams@petalogix.com
In-Reply-To: <20090323205305.GA10576@oksana.dev.rtsoft.ru>
References: <1237408284-8674-1-git-send-email-monstr@monstr.eu>
	 <4b5aee01d11fc790c7842838ea63a82ee3273003.1237407249.git.monstr@monstr.eu>
	 <af309ba8e95f503b7990461384d9f8453f45dbbd.1237407249.git.monstr@monstr.eu>
	 <200903231951.23902.arnd@arndb.de>
	 <20090323205305.GA10576@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Thu, 26 Mar 2009 11:01:39 +1100
Message-Id: <1238025699.25062.756.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 23:53 +0300, Anton Vorontsov wrote:
> It took me approx. 4 hours to factor out the code and make a
> proof-of-concept FDT support for a little-endian ARM platform. ;-)
> (The device tree was only describing a cpu and a nor flash, though.
> No support for interrupt- and gpio-controllers. And no support for
> U-Boot, I just built the dtb file into the kernel).

ARM could benefit tremendously I believe from a similar virtualized
interrupt mapping & OF tree to powerpc for their gazillions of weirdly
cascaded interrupt controller setups :-)

Ben.


