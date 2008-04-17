Return-Path: <linux-kernel-owner+w=401wt.eu-S934810AbYDQSD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810AbYDQSD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 14:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765611AbYDQSDW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 14:03:22 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:36522 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765550AbYDQSDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 14:03:21 -0400
Date: Thu, 17 Apr 2008 21:08:44 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       serue@us.ibm.com, penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org
Subject: Re: [Fwd: [-mm] Add an owner to the mm_struct (v9)]
Message-ID: <20080417170844.GA5575@tv-sign.ru>
References: <48036677.3010807@linux.vnet.ibm.com> <20080414170709.736819b6.akpm@linux-foundation.org> <20080415171359.GA352@tv-sign.ru> <6599ad830804151113i73010bb4x48e658195f295d41@mail.gmail.com> <20080415195950.GA113@tv-sign.ru> <4806C633.3000302@linux.vnet.ibm.com> <20080417113000.GB103@tv-sign.ru> <6599ad830804170934i6df9fe42kd979492babe03be@mail.gmail.com> <20080417161936.GB4482@tv-sign.ru> <48078B9B.9070508@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48078B9B.9070508@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, Balbir Singh wrote:
> 
> Oleg Nesterov wrote:
> >> CLONE_THREAD without CLONE_VM when creating a new subthread.
> > 
> > No, no, this is not possible/allowed.
> > 
> > Please look at copy_process, CLONE_THREAD requires CLONE_SIGHAND,
> > CLONE_SIGHAND needs CLONE_VM.
> > 
> 
> What about the other way round, CLONE_VM without CLONE_THREAD?

Yes, this is possible, and this is why mm_update_next_owner() has to be so
complicated. The same for zap_threads/elf_core_dump.

If only I knew why we allow CLONE_VM! except for CLONE_THREAD/CLONE_VFORK
of course, but there are trivial.


And thanks to you and Paul for your explanations.

Oleg.

