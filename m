Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbXENTDv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbXENTDv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:03:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbXENTDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:03:44 -0400
Received: from gw.goop.org ([64.81.55.164]:42624 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354AbXENTDn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:03:43 -0400
Message-ID: <4648B28A.5000800@goop.org>
Date: Mon, 14 May 2007 12:03:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, Andi Kleen <ak@suse.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com>	 <46489818.4000408@goop.org> <1179163348.3703.57.camel@mulgrave.il.steeleye.com>
In-Reply-To: <1179163348.3703.57.camel@mulgrave.il.steeleye.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> No, I'm proposing this for 2.6.22-rc1 ... Andi has already said he won't
> push the smp consolidation patch for 2.6.22.
>
> Without this patch, voyager won't even build, since the smp_ops broke
> it, so it needs to be fixed *now*.
>   

Sure, I suppose.  But given that the patch which fixes this is a simple
no-functional-changes code-motion patch, it seems odd to not use it in
favour of putting in a big chunk of duplicated code.

    J

