Return-Path: <linux-kernel-owner+w=401wt.eu-S965287AbXDKUSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965287AbXDKUSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 16:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965275AbXDKUSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 16:18:22 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45836 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965287AbXDKUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 16:18:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Bill Davidsen <davidsen@tmr.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>, Ingo Molnar <mingo@elte.hu>,
       Robin Holt <holt@sgi.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@americas.sgi.com>
Subject: Re: init's children list is long and slows reaping children.
References: <46159987.6090006@redhat.com>
	<Pine.LNX.4.64.0704051825400.6730@woody.linux-foundation.org>
	<m1hcru9rki.fsf@ebiederm.dsl.xmission.com>
	<20070406104301.GB19755@lnx-holt.americas.sgi.com>
	<m1mz1l8qdr.fsf@ebiederm.dsl.xmission.com>
	<20070406163100.GA554@tv-sign.ru> <20070406173249.GA2517@elte.hu>
	<m11wix73ut.fsf@ebiederm.dsl.xmission.com>
	<20070410134814.GA28016@elte.hu>
	<m17iskz3i8.fsf@ebiederm.dsl.xmission.com>
	<20070410164441.GB104@tv-sign.ru> <461D3D3E.2060709@tmr.com>
Date: Wed, 11 Apr 2007 14:17:13 -0600
In-Reply-To: <461D3D3E.2060709@tmr.com> (Bill Davidsen's message of "Wed, 11
	Apr 2007 15:55:42 -0400")
Message-ID: <m1veg2r7hy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen <davidsen@tmr.com> writes:

> As long as the original parent is preserved for getppid(). There are programs
> out there which communicate between the parent and child with signals, and if
> the original parent dies, it undesirable to have the child getppid() and start
> sending signals to a program not expecting them. Invites undefined behavior.

Then the programs are broken.  getppid is defined to change if the process
is reparented to init.

Eric
