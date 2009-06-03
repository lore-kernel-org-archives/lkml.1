Return-Path: <linux-kernel-owner+w=401wt.eu-S1755405AbZFCTug@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405AbZFCTug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 15:50:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZFCTu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 15:50:29 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:49563 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751329AbZFCTu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 15:50:29 -0400
Date: Wed, 3 Jun 2009 15:50:17 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Larry H." <research@subreption.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, pageexec@freemail.hu
Subject: Re: Security fix for remapping of page 0 (was [PATCH] Change
 ZERO_SIZE_PTR to point at unmapped space)
In-Reply-To: <alpine.LFD.2.01.0906031222550.4880@localhost.localdomain>
Message-ID: <alpine.DEB.1.10.0906031547090.20254@gentwo.org>
References: <20090530230022.GO6535@oblivion.subreption.com> <alpine.LFD.2.01.0905301902010.3435@localhost.localdomain> <20090531022158.GA9033@oblivion.subreption.com> <alpine.DEB.1.10.0906021130410.23962@gentwo.org> <20090602203405.GC6701@oblivion.subreption.com>
 <alpine.DEB.1.10.0906031047390.15621@gentwo.org> <20090603182949.5328d411@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0906031032390.4880@localhost.localdomain> <20090603180037.GB18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031109150.4880@localhost.localdomain>
 <20090603183939.GC18561@oblivion.subreption.com> <alpine.LFD.2.01.0906031142390.4880@localhost.localdomain> <alpine.LFD.2.01.0906031145460.4880@localhost.localdomain> <alpine.DEB.1.10.0906031458250.9269@gentwo.org>
 <alpine.LFD.2.01.0906031222550.4880@localhost.localdomain>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Linus Torvalds wrote:

> But the better option really is to just copy the cap_file_mmap() rule to
> the !SECURITY rule, and make !SECURITY really mean the same as "always do
> default security", the way it's documented.

Na, I really like the ability to just avoid having to deal with this
"security" stuff (CONFIG_SECURITY). And core security checks sidelined in
some security model config thingy? I'd prefer to see these checks right
there in core code while working on them.


