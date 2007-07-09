Return-Path: <linux-kernel-owner+w=401wt.eu-S1757975AbXGIVxz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975AbXGIVxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:53:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXGIVxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:53:47 -0400
Received: from styx.suse.cz ([82.119.242.94]:47930 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755445AbXGIVxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:53:46 -0400
Date: Mon, 9 Jul 2007 23:58:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Chuck Ebbert <cebbert@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Kratochvil <honza@jikos.cz>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Ernie Petrides <petrides@redhat.com>
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <Pine.LNX.4.64.0707091333230.11634@jikos.suse.cz>
Message-ID: <Pine.LNX.4.64.0707092356450.11634@jikos.suse.cz>
References: <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
 <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
 <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
 <20070522161642.b71ddacb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com>
 <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz> <468D5A3A.1010306@redhat.com>
 <468D5B28.8080308@redhat.com> <Pine.LNX.4.64.0707070205460.11634@jikos.suse.cz>
 <20070707123004.GZ7012@devserv.devel.redhat.com> <Pine.LNX.4.64.0707091333230.11634@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2007, Jiri Kosina wrote:

> > Signed-off-by: Jakub Jelinek <jakub@redhat.com>
> [ ... ]
> > -			if (!BAD_ADDR(elf_entry)) {
> > +			if (!IS_ERR((void *)elf_entry)) {
> I agree that this is better solution. Andrew, this Jakub's patch should 
> replace the pie-randomization-fix-bad_addr-macro.patch if possible. You 
> can add 

Hi Jakub,

as this raced :) with Andrew who already folded the 
pie-randomization-fix-bad_addr-macro.patch into pie-randomization.patch, 
do you think you could rebase this change against the current state of -mm 
and resend it? Thanks,

-- 
Jiri Kosina
SUSE Labs
