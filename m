Return-Path: <linux-kernel-owner+w=401wt.eu-S965584AbXDJWRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965584AbXDJWRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965687AbXDJWRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:17:41 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:37953 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965584AbXDJWRk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:17:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/2] Account for module percpu space separately from kernel percpu
References: <461BC4B6.9060006@goop.org>
Date: Tue, 10 Apr 2007 16:16:43 -0600
In-Reply-To: <461BC4B6.9060006@goop.org> (Jeremy Fitzhardinge's message of
	"Tue, 10 Apr 2007 10:09:10 -0700")
Message-ID: <m1abxfyiwk.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> Rather than using a single constant PERCPU_ENOUGH_ROOM, compute it as
> the sum of kernel_percpu + PERCPU_MODULE_RESERVE.  This is now common
> to all architectures; if an architecture wants to set
> PERCPU_ENOUGH_ROOM to something special, then it may do so (ia64 is
> the only one which does).

I think I have already done this but in case I haven't.
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I see any problems there.
