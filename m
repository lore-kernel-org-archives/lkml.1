Return-Path: <linux-kernel-owner+w=401wt.eu-S1760826AbXLLTgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760826AbXLLTgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:36:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758223AbXLLTgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:36:33 -0500
Received: from gw.goop.org ([64.81.55.164]:48989 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754625AbXLLTgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:36:32 -0500
Message-ID: <4760383C.2040502@goop.org>
Date: Wed, 12 Dec 2007 11:36:28 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: 7eggert@gmx.de, Andrew Morton <akpm@linux-foundation.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: relax signature check
References: <9yY38-5oa-11@gated-at.bofh.it>	<E1J27Or-00012X-DF@be1.7eggert.dyndns.org> <475EC5E5.80104@goop.org> <47603332.8060605@codemonkey.ws>
In-Reply-To: <47603332.8060605@codemonkey.ws>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> If xen-32.0 should be compatible than wouldn't xen-24.0 be compatible
> too?  I think the point was that you should either be checking for
> 'xen-3.x' or something more general that would accept anything >=
> xen-3.0.

The signature is supposed to be an ABI signature, so regardless of the
actual hypervisor version, it should always present "xen-3.0"
(presumably backwards compat if it also supports other versions of the
ABI).  There was a bug in some versions where it puts the actual
hypervisor version in there, requiring this patch.  Technically that
means that looking for "xen-3." is more accurate, but frankly not
important enough to bother raising a patch over.

    J
