Return-Path: <linux-kernel-owner+w=401wt.eu-S968047AbXEHN41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968047AbXEHN41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968012AbXEHN4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:56:23 -0400
Received: from khc.piap.pl ([195.187.100.11]:51784 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967498AbXEHN4W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:56:22 -0400
To: Michael-Luke Jones <mlj28@cam.ac.uk>
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] Intel IXP4xx network drivers v.2 - NPE
References: <m3abwhcy74.fsf@maximus.localdomain>
	<m3vef5biob.fsf@maximus.localdomain>
	<5BB7E1AB-5CE1-43C8-8CE3-E0DE0236BD09@cam.ac.uk>
	<m3hcqoa772.fsf@maximus.localdomain>
	<86D26EBE-5899-468F-9C79-23E83E0DE04B@cam.ac.uk>
	<m33b289zku.fsf@maximus.localdomain>
	<m33b285exl.fsf_-_@maximus.localdomain>
	<8CA5FD65-BEE1-4769-B1DF-81CA82210F61@cam.ac.uk>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 08 May 2007 15:56:20 +0200
In-Reply-To: <8CA5FD65-BEE1-4769-B1DF-81CA82210F61@cam.ac.uk> (Michael-Luke Jones's message of "Tue, 8 May 2007 08:02:15 +0100")
Message-ID: <m3sla77723.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael-Luke Jones <mlj28@cam.ac.uk> writes:

> Already in mach-ixp4xx, so can just be called npe.c

I want ixp4xx_ prefix in module name, otherwise I'd call it npe.c,
sure.

> Debugging code? Can this go?

Why? Especially with code having to work with third party binary-only
firmware? Suicide. They are eliminated at build time = performance
hit (OTOH this file isn't on any fast path).

> It may be a matter of taste, but could some of the many definitions
> at the top of ixp4xx_npe.c go in the header file here?

It's actually not only a matter of taste, they are private
to the .c file and I don't want to make them available to the
public (but sure, I don't like them in .c either, I think nobody
likes such definitions anywhere but they have to exist somewhere).
-- 
Krzysztof Halasa
