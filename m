Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZFCVVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZFCVVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 17:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755275AbZFCVVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 17:21:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36235 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754064AbZFCVVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 17:21:47 -0400
Date: Wed, 3 Jun 2009 14:20:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Christoph Lameter <cl@linux-foundation.org>
cc: Eric Paris <eparis@parisplace.org>, "Larry H." <research@subreption.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <alpine.DEB.1.10.0906031602250.20254@gentwo.org>
Message-ID: <alpine.LFD.2.01.0906031414570.4880@localhost.localdomain>
References: <20090530230022.GO6535@oblivion.subreption.com>  <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain>  <20090603180037.GB18561@oblivion.subreption.com>  <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>  <20090603183939.GC18561@oblivion.subreption.com>
  <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain>  <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>  <alpine.DEB.1.10.0906031458250.9269@gentwo.org>  <7e0fb38c0906031214lf4a2ed2x688da299e8cb1034@mail.gmail.com> 
 <alpine.DEB.1.10.0906031537110.20254@gentwo.org> <7e0fb38c0906031251h6844ea08y2dbfa09a7f46eb5f@mail.gmail.com> <alpine.DEB.1.10.0906031602250.20254@gentwo.org>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Jun 2009, Christoph Lameter wrote:
> 
> Use mmap_min_addr indepedently of security models

Looks ok by me. As mentioned, it would be nice if the coherency with the 
'capabilities' security module was something inherent to the code, but 
this looks like a sane minimal patch.

			Linus
