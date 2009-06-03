Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZFCQOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZFCQOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZFCQOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:14:22 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60862 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752581AbZFCQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:14:22 -0400
Date: Wed, 3 Jun 2009 17:14:09 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Lameter <cl@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
Message-ID: <20090603171409.5c60422c@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.01.0906030827580.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com>
	<alpine.LFD.2.01.0905301528540.3435@localhost.localdomain>
	<20090530230022.GO6535@oblivion.subreption.com>
	<alpine.LFD.2.01.0905301902010.3435@localhost.localdomain>
	<20090531022158.GA9033@oblivion.subreption.com>
	<alpine.DEB.1.10.0906021130410.23962@gentwo.org>
	<20090602203405.GC6701@oblivion.subreption.com>
	<alpine.DEB.1.10.0906031047390.15621@gentwo.org>
	<alpine.LFD.2.01.0906030800490.4880@localhost.localdomain>
	<alpine.DEB.1.10.0906031121030.15621@gentwo.org>
	<alpine.LFD.2.01.0906030827580.4880@localhost.localdomain>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It defaults to 64kB in at least the x86 defconfig files, but to 0 in the 
> Kconfig defaults. Also, for some reason it has a "depends on SECURITY", 
> which means that if you just default to the old-style unix security you'll 
> lose it.
> 
> So there are several ways to disable it by mistake. I don't know what 
> distros do.

Fedora at least uses SELinux to manage it. You need some kind of security
policy engine running as a few apps really need to map low space (mostly
for vm86)

