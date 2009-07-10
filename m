Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZGJV2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZGJV2z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752337AbZGJV2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:28:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751323AbZGJV2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:28:43 -0400
Date: Fri, 10 Jul 2009 14:27:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Yinghai Lu <yinghai@kernel.org>
cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       dann frazier <dannf@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       linux-scsi@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org, Stephen Frost <sfrost@snowman.net>
Subject: Re: [PATCH] x86/pci: insert ioapic resource before assign unassigned
 resource for pci -v2
In-Reply-To: <4A576E04.9070004@kernel.org>
Message-ID: <alpine.LFD.2.01.0907101426490.3352@localhost.localdomain>
References: <20090630180300.GA9971@ldl.fc.hp.com>  <4A4A5B01.9040200@kernel.org> <20090703225708.GA30664@ldl.fc.hp.com>  <4A4FADDC.30606@kernel.org> <20090709185945.GG2613@ldl.fc.hp.com>  <4A564263.5010305@kernel.org> <4A564634.1020708@kernel.org> 
 <4A564990.3060202@kernel.org> <1247172044.3898.147.camel@mulgrave.site> <4A56641B.9050204@kernel.org> <4A576E04.9070004@kernel.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jul 2009, Yinghai Lu wrote:
> 
> solution is trying to insert ioapic_resource early a little bit.
> 
> v2: update comments

Ack, looks sane to me.

		Linus
