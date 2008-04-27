Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbYD0W5d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbYD0W5d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 18:57:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYD0W5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 18:57:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40283 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbYD0W5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 18:57:25 -0400
Message-ID: <481504BA.4090402@zytor.com>
Date: Sun, 27 Apr 2008 15:56:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: David Miller <davem@davemloft.net>, James.Bottomley@HansenPartnership.com,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [patch] x86, voyager: fix ioremap_nocache()
References: <20080427214837.GA11631@elte.hu>	<1209335660.3801.79.camel@localhost.localdomain>	<4815009C.2010809@garzik.org> <20080427.154620.177583216.davem@davemloft.net> <481503ED.8060107@garzik.org>
In-Reply-To: <481503ED.8060107@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> 
> Understood.
> 
> I guess I am more annoyed that this stealth semantics change appears to 
> have broken everything that depends on pci_iomap(), including 90%+ of 
> all libata drivers, unless I am missing something.
> 
> That one piece of code (pci_iomap) was correct under the old semantics, 
> on x86 and elsewhere.  It's tested and working nicely, and depended upon 
> by many drivers.
> 

That one piece of code has had no effective change.  Under both the old 
and the new code, both branches functionally because ioremap_nocache(), 
in one case because of MTRR and in one case because of PAT.

	-hpa
