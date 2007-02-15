Return-Path: <linux-kernel-owner+w=401wt.eu-S1161567AbXBOWjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161567AbXBOWjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 17:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161578AbXBOWja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 17:39:30 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:51385 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161567AbXBOWja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 17:39:30 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-mm1
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
	<45D47020.1010309@googlemail.com>
	<20070215140232.0aba86a7.akpm@linux-foundation.org>
Date: Thu, 15 Feb 2007 15:38:25 -0700
In-Reply-To: <20070215140232.0aba86a7.akpm@linux-foundation.org> (Andrew
	Morton's message of "Thu, 15 Feb 2007 14:02:32 -0800")
Message-ID: <m164a3jbby.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> That's shm-make-sysv-ipc-shared-memory-use-stacked-files.patch, brought to
> us by Eric-who-hasnt-read-Documentation/SubmitChecklist.

Sorry I thought I had all of the interesting debugging enabled in my
kernel build.  It must of fallen out someplace.  I think I must
have figured shm_lock was a semaphore or mutex.

> Like this, I guess:

Nope.  get_empty_filp can sleep as well, unless I'm totally mistaken.
It looks like the logic change is going to be a little more than a one
liner.  I will get back to you in a couple of hours....

Eric
