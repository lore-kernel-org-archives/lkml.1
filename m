Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZDNQkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZDNQkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZDNQj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:39:57 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:59118 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167AbZDNQj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:39:56 -0400
Subject: Re: [PATCH 10/30] cr: core stuff
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, xemul@parallels.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20090414160003.GD27461@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain>
	 <49E41D7B.8030003@cs.columbia.edu>
	 <20090414160003.GD27461@x200.localdomain>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 09:39:50 -0700
Message-Id: <1239727190.32604.72.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 20:00 +0400, Alexey Dobriyan wrote:
> > Are you suggesting that conversion of a checkpoint image from an older
> > version to a newer version be done in the kernel ?
> 
> For mainline kernel it's completely unrealistic to support all backwards
> compatibility code for previous versions. Some mythical userspace
> program will convert images.
> 
> But it's completely realistic and much easier for distro kernel because
> distro kernel doesn't generally include patches with significant in-kernel
> internals changes, so they simply can support
> '2.6.26-1-amd64' => '2.6.26-2-amd64' situation.
> 
> Distros can write conversion program too, but I don't expect they will.

Yeah, I'm with you on this.  If distros ever start to care about c/r
*that* much, they'll start making this part of their testing process.
Personally, I think just giving a kernel version is pretty worthless
these days.  People do tons of stuff to the kernel without bumping it at
all. 

-- Dave

