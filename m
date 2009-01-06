Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbZAFSsw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbZAFSsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:48:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbZAFSsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:48:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36739 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbZAFSsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:48:35 -0500
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] waitfd
From: Andi Kleen <andi@firstfloor.org>
References: <49639EB8.40204@redhat.com>
Date: Tue, 06 Jan 2009 19:48:37 +0100
In-Reply-To: <49639EB8.40204@redhat.com> (Casey Dahlin's message of "Tue, 06 Jan 2009 13:11:04 -0500")
Message-ID: <87fxjw46ey.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Dahlin <cdahlin@redhat.com> writes:

> Linux now exposes signals, timers, and events via file descriptors
> through signalfd, timerfd, and eventfd. This means programmers can use
> a single select/[e]poll call to monitor all change in their
> program. This patch aims to expose child death via the same mechanism.
>
> waitfd provides a file descriptor out of which may be read a series of
> siginfo_t objects describing child death. A child process is reaped as
> soon as its information is read. This means child monitoring too can
> be performed with that same poll call.
>
> Patch is against v2.6.28

Can you please provide a manpage with the exact proposed semantics of
the interface.

Without that it's very hard to evaluate if the interface makes sense
or not.

In general a single paragraph is not enough to justify a new system 
call.

-Andi

-- 
ak@linux.intel.com
