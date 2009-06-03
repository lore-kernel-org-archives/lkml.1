Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZFCUgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZFCUgm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZFCUgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:36:35 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:51998 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751583AbZFCUge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:36:34 -0400
Date: Wed, 3 Jun 2009 16:36:19 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Eric Paris <eparis@parisplace.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Larry H." <research@subreption.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-mm@kvack.org,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       pageexec@freemail.hu, jmorris@namei.org
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change 
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <7e0fb38c0906031316n7aeed974xf15f8af5a3b04f63@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0906031635070.9368@gentwo.org>
References: <20090530230022.GO6535@oblivion.subreption.com>  <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>  <20090603183939.GC18561@oblivion.subreption.com>  <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain> 
 <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain>  <alpine.DEB.1.10.0906031458250.9269@gentwo.org>  <7e0fb38c0906031214lf4a2ed2x688da299e8cb1034@mail.gmail.com>  <alpine.DEB.1.10.0906031537110.20254@gentwo.org>  <7e0fb38c0906031251h6844ea08y2dbfa09a7f46eb5f@mail.gmail.com>
  <alpine.DEB.1.10.0906031602250.20254@gentwo.org> <7e0fb38c0906031316n7aeed974xf15f8af5a3b04f63@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Eric Paris wrote:

> > Thats easy to do but isnt it a bit weird now to configure mmap_min_addr?
>
> ??

The use of mmap_min_addr depends on the security configuration chose. The
security model may not check at all. But we can still configure the thing.

> > What about round_hint_to_min()?
>
> not sure what you mean....

We removed the CONFIG_SECURITY around code in there in the patch.

