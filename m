Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbXK3Vga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbXK3Vga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbXK3VgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:36:22 -0500
Received: from namei.org ([69.55.235.186]:42004 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751107AbXK3VgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:36:21 -0500
Date: Sat, 1 Dec 2007 08:36:15 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Crispin Cowan <crispin@crispincowan.com>
cc: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: Out of tree module using LSM
In-Reply-To: <47507818.8010808@crispincowan.com>
Message-ID: <Xine.LNX.4.64.0712010824170.5027@us.intercode.com.au>
References: <47507818.8010808@crispincowan.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Crispin Cowan wrote:

> restored faces a lot of challenges, but I hope that some kind of
> solution can be found, because the alternative is to effectively force
> vendors like Sophos to do it the "dirty" way by fishing in memory for
> the syscall table.

I don't think this is quite correct.

The alternative is to engage with the kernel community to become part of 
the development process, to ensure that appropriate APIs are implemented, 
and to get code upstream before shipping it.

In any case, a patch to revert the dynamic aspect of LSM has been posted 
by Arjan (and acked by myself) for the case of valid out of tree users.  
The only case of this so far has been Multiadm, although there seems to be 
no reason for it to stay out of tree.



- James
-- 
James Morris 
<jmorris@namei.org>

