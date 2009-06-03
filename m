Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbZFCSNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbZFCSNi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 14:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752058AbZFCSNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 14:13:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39506 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751237AbZFCSNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 14:13:31 -0400
Date: Wed, 3 Jun 2009 11:12:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Larry H." <research@subreption.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <20090603180037.GB18561@oblivion.subreption.com>
Message-ID: <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com>
 <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <20090603182949.5328d411@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain>
 <20090603180037.GB18561@oblivion.subreption.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Larry H. wrote:
> 
> Are you saying that a kernel exploit can't be leveraged by means of
> runtime code injection for example?

No. I'm sayng that sane people don't get hung up about every little 
possibility.

Why are security people always so damn black-and-white? In most other 
areas, such people are called "crazy" or "stupid", but the security people 
seem to call them "normal".

The fact, the NULL pointer attack is neither easy nor common. It's 
perfectly reasonable to say "we'll allow mmap at virtual address zero".

Disallowing NULL pointer mmap's is one small tool in your toolchest, and 
not at all all-consumingly important or fundamental. It's just one more 
detail.

Get over it. Don't expect everybody to be as extremist as you apparently 
are.

			Linus
