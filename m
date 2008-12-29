Return-Path: <linux-kernel-owner+w=401wt.eu-S1754686AbYL2KFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbYL2KFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbYL2KF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:05:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625AbYL2KF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:05:27 -0500
Message-ID: <4958A015.1070007@kernel.org>
Date: Mon, 29 Dec 2008 02:01:57 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Jaswinder Singh Rajput <jaswinder@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, mj@ucw.cz
Subject: Re: [PATCH] move arch/x86/pci/pci.h to	arch/x86/include/asm/pci_x86.h
References: <1230382948.3373.1.camel@jaswinder.satnam> <20081229065713.GA10960@x200.localdomain> <1230537538.3090.4.camel@jaswinder.satnam> <20081229084851.GA12756@x200.localdomain>
In-Reply-To: <20081229084851.GA12756@x200.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> 
> So you don't actually have an opinion? Why are you sending patch then?
> 
> 	> could you send another patch that moves arch/x86/pci/pci.h to 
> 	> arch/x86/include/asm/pci_x86.h
> 	       ^^^		   ^^^
> Or should it be arch/x86/include/asm/pci.h ?
> 

<asm/pci.h> already exists, though.  This file contains definitions
private to the x86 implementation, whereas <asm/pci.h> contains arch
implementations of panarchitectural interfaces.

The reason for moving it was to avoid ugly ../ paths.

	-hpa
