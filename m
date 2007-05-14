Return-Path: <linux-kernel-owner+w=401wt.eu-S1758898AbXENUJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898AbXENUJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbXENUJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:09:43 -0400
Received: from mail.suse.de ([195.135.220.2]:50659 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbXENUJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:09:42 -0400
From: Andi Kleen <ak@suse.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [VOYAGER] fix build broken by shift to smp_ops
Date: Mon, 14 May 2007 22:09:05 +0200
User-Agent: KMail/1.9.1
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Andrew Morton <akpm@osdl.org>, Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <1179158912.3703.47.camel@mulgrave.il.steeleye.com> <1179163348.3703.57.camel@mulgrave.il.steeleye.com> <4648B28A.5000800@goop.org>
In-Reply-To: <4648B28A.5000800@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705142209.05676.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 21:03, Jeremy Fitzhardinge wrote:
> James Bottomley wrote:
> > No, I'm proposing this for 2.6.22-rc1 ... Andi has already said he won't
> > push the smp consolidation patch for 2.6.22.
> >
> > Without this patch, voyager won't even build, since the smp_ops broke
> > it, so it needs to be fixed *now*.
>
> Sure, I suppose.  But given that the patch which fixes this is a simple
> no-functional-changes code-motion patch, it seems odd to not use it in
> favour of putting in a big chunk of duplicated code.

Ok. If it's just the code movement patch that's needed perhaps it's better
to use that.

-Andi
