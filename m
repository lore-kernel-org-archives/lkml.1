Return-Path: <linux-kernel-owner+w=401wt.eu-S1755310AbZHGVDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbZHGVDL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 17:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbZHGVDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 17:03:10 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38399 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZHGVDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 17:03:09 -0400
Date: Fri, 7 Aug 2009 23:03:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Amerigo Wang <amwang@redhat.com>, Neil Horman <nhorman@redhat.com>,
       linux-kernel@vger.kernel.org, tony.luck@intel.com,
       linux-ia64@vger.kernel.org, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Anton Vorontsov <avorontsov@ru.mvista.com>,
       Andi Kleen <andi@firstfloor.org>,
       Bernhard Walle <bernhard.walle@gmx.de>,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [Patch 0/7] Implement crashkernel=auto
Message-ID: <20090807210306.GA25609@basil.fritz.box>
References: <4A7A3A78.7080200@redhat.com> <m1y6pxr737.fsf@fess.ebiederm.org> <4A7A506B.2060008@redhat.com> <m1ljlxsiox.fsf@fess.ebiederm.org> <4A7A70E5.2010204@redhat.com> <m1bpmtqxjh.fsf@fess.ebiederm.org> <4A7A7A0F.6070906@redhat.com> <m1iqh1nxv3.fsf@fess.ebiederm.org> <4A7A9E54.60705@redhat.com> <m1iqgze740.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1iqgze740.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As an initial approximation I would use a 32nd of low memory.

That means a 1TB machine will have a 32GB crash kernel.

Surely that's excessive?!?

It would be repeating all the same mistakes people made with hash tables
several years ago.

> 
> That can be written to (with enough privileges when no crash kernel is
> loaded) reduce the amount of memory reserved by the crash kernel.
> 
> Bernhard does that sound useful to you?
> 
> Amerigo does that seem reasonable?

It doesn't sound reasonable to Andi.

Why do you even want to grow the crash kernel that much? Is there
any real problem with a 64-128MB crash kernel?

-Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
