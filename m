Return-Path: <linux-kernel-owner+w=401wt.eu-S1758289AbZFCQWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758289AbZFCQWN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 12:22:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbZFCQV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 12:21:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756275AbZFCQV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 12:21:58 -0400
Date: Wed, 3 Jun 2009 09:19:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Christoph Lameter <cl@linux-foundation.org>,
       "Larry H." <research@subreption.com>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <20090603171409.5c60422c@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.01.0906030918490.4880@localhost.localdomain>
References: <20090530192829.GK6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301528540.3435@localhost.localdomain> <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com>
 <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com> <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <alpine.LFD.2.01.0906030800490.4880@localhost.localdomain> <alpine.DEB.1.10.0906031121030.15621@gentwo.org>
 <alpine.LFD.2.01.0906030827580.4880@localhost.localdomain> <20090603171409.5c60422c@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Alan Cox wrote:
> 
> Fedora at least uses SELinux to manage it. You need some kind of security
> policy engine running as a few apps really need to map low space (mostly
> for vm86)

Well, vm86 isn't even an issue on x86-64, so it's arguable that at least a 
few cases could very easily just make it more static and obvious.

			Linus
