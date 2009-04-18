Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbZDRSt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbZDRSt0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756472AbZDRStS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:49:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37681 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754098AbZDRStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:49:17 -0400
Date: Sat, 18 Apr 2009 11:42:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: [PATCH] pci: keep pci device resource name pointer right.
In-Reply-To: <49E96731.1000501@kernel.org>
Message-ID: <alpine.LFD.2.00.0904181141100.4042@localhost.localdomain>
References: <49E52D3F.1090206@kernel.org> <20090416093152.6605612d@hobbes> <alpine.LFD.2.00.0904160938090.4042@localhost.localdomain> <20090416165640.GA13927@elte.hu> <49E76864.9060309@kernel.org> <20090416172803.GB16618@elte.hu> <49E7916C.7050701@kernel.org>
 <alpine.LFD.2.00.0904161540590.4042@localhost.localdomain> <20090416235452.GE21405@elte.hu> <alpine.LFD.2.00.0904161716270.4042@localhost.localdomain> <20090417131633.GA30578@elte.hu> <49E8FD0B.2050308@zytor.com> <49E96731.1000501@kernel.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Yinghai Lu wrote:
> 
> it turns that we need to reget res->name because dev->dev.kobj name is changed
> after device_add.

Can we not make the rule be that the name should just be set before?

IOW, there is something else broken, I think. Rather than put this ugly 
band-aid, why now make sure that whoever had that broken name fixes it?

		Linus
