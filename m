Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbXI3PJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbXI3PJV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 11:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbXI3PJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 11:09:15 -0400
Received: from mail.suse.de ([195.135.220.2]:33110 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756934AbXI3PJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 11:09:13 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <npiggin@suse.de>
Subject: Re: [rfc][patch] i386: remove comment about barriers
Date: Sun, 30 Sep 2007 17:09:08 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Paul McKenney <paulmck@us.ibm.com>, David Howells <dhowells@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070929132848.GA21169@wotan.suse.de>
In-Reply-To: <20070929132848.GA21169@wotan.suse.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200709301709.08242.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> mb() and smp_mb() always have and always will require a full mfence or lock
> prefixed instruction on x86. And we should remove this comment.

Thanks for the detailed explanation. I queued the patch.

-Andi

