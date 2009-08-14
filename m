Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZHNRfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZHNRfw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 13:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756328AbZHNRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 13:35:51 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:60460 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756078AbZHNRfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 13:35:51 -0400
From: Frans Pop <elendil@planet.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: PCI resources allocation problem on Toshiba Satellite A40
Date: Fri, 14 Aug 2009 19:35:39 +0200
User-Agent: KMail/1.9.9
Cc: mano@roarinelk.homelinux.net, rjw@sisk.pl, willy@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       akpm@linux-foundation.org, andrew.patterson@hp.com
References: <200908021619.48285.rjw@sisk.pl> <200908141850.44736.elendil@planet.nl> <alpine.LFD.2.01.0908140957050.3162@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0908140957050.3162@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908141935.41529.elendil@planet.nl>
X-OriginalArrivalTime: 14 Aug 2009 17:35:52.0056 (UTC) FILETIME=[AB5D9780:01CA1D05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Linus Torvalds wrote:
> So the fact that it "worked" for a few kernels was simply due to a
> kernel bug, where "pci_claim_resource()" incorrectly allowed the
> resource to be inserted into a resource window that wasn't actually its
> parent, and a crazy BIOS that did crazy things, together with a chipset
> where those crazy things just _happened_ to work because of how
> decoding was done.

OK. Thanks for taking a look. I'll happily ignore the error messages from 
now on. Luckily confirmation that things work correctly when faced with 
broken BIOSes can be useful too :-)

Cheers,
FJP
