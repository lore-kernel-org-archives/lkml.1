Return-Path: <linux-kernel-owner+w=401wt.eu-S1161149AbXDLKqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161149AbXDLKqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992462AbXDLKqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:46:54 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57211 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161149AbXDLKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:46:53 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch] uninline remove/add_parent() APIs
References: <20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu>
	<m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
	<20070410150650.GA9946@elte.hu>
	<m1tzvoxniv.fsf@ebiederm.dsl.xmission.com>
	<20070410155314.GA16267@elte.hu> <20070411062041.GA8017@elte.hu>
	<m1ps6btmym.fsf@ebiederm.dsl.xmission.com>
	<20070411150614.bfaa4ae0.akpm@linux-foundation.org>
Date: Thu, 12 Apr 2007 04:45:40 -0600
In-Reply-To: <20070411150614.bfaa4ae0.akpm@linux-foundation.org> (Andrew
	Morton's message of "Wed, 11 Apr 2007 15:06:14 -0700")
Message-ID: <m1mz1drhuz.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 11 Apr 2007 01:00:17 -0600
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> Should we copy Andrew or is someone else going to collect up all of these
> patches?
>
> Andrew is cowering in terror, because utrace goes tromping through this
> code.
>
> It would be rather good to get utrace moving along a bit more quickly.  There
> still seem to be rather a lot of issues.

Just on that note roughly where is utrace?

My first impression is that it appears to cleanup a little bit of
child list handling at the cost of 2000 lines of extra code.

Eric



