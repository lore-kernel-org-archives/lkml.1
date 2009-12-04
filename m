Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbZLDCho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbZLDCho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 21:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753638AbZLDChm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 21:37:42 -0500
Received: from gate.crashing.org ([63.228.1.57]:38575 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbZLDChl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 21:37:41 -0500
Subject: Re: [PATCH] powerpc/mm: setting mmaped page cache property through
 device tree
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Li Yang <leoli@freescale.com>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
References: <1259663450-28790-1-git-send-email-leoli@freescale.com>
	 <1259665127.2076.363.camel@pasglop>
	 <2a27d3730912010334q24bf0e06g84839aae131475ec@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 13:37:37 +1100
Message-ID: <1259894257.2076.1244.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 19:34 +0800, Li Yang wrote:
> The scenario for the second case is to pre-allocate some memory to a
> certain application or device (probably through mem=XXX kernel
> parameter or limit through device tree).  The memory is not known to
> kernel, but fully managed by the application/device.  We need being
> able to map the region cachable for better performance.
> 
> > trying to achieve here ? We can find a solution though it might
> involve
> > a specific driver to handle that memory.
> 
> Right, but what the user to kernel API should be used?  Is it ok to
> use the O_SYNC flag as I previously proposed? 

If it's cachable, why don't you write yourself a little driver that
allocates memory maps it to userspace and provides you with the physical
addresses and problem solved ?

Cheers,
Ben.

