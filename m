Return-Path: <linux-kernel-owner+w=401wt.eu-S1757921AbZDRWZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921AbZDRWZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 18:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZDRWY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 18:24:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43020 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbZDRWY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 18:24:56 -0400
Date: Sat, 18 Apr 2009 15:17:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [PATCH] pci: keep pci device resource name pointer right.
In-Reply-To: <1240086446.2411.9.camel@poy>
Message-ID: <alpine.LFD.2.00.0904181516530.2199@localhost.localdomain>
References: <20090416172803.GB16618@elte.hu>  <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain>  <20090416235452.GE21405@elte.hu>  <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain>  <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com>
  <49E96731.1000501@kernel.org>  <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain>  <49EA27B9.3030004@kernel.org> <20090418192314.GA22107@suse.de>  <ac3eb2510904181300v2593c36dua6c2420828860706@mail.gmail.com> <1240086446.2411.9.camel@poy>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Apr 2009, Kay Sievers wrote:
> 
> Only to see if we are on the right track, does that fix the problem? If
> yes, we will fix it properly without the NULL hack deep in the kobject
> call.

ACK, this patch looks much saner, and would seem to address the core 
issue.

		Linus
