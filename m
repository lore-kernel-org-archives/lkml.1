Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXELG3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXELG3b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 02:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbXELG3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 02:29:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37591 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbXELG3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 02:29:24 -0400
Message-ID: <46455EB4.901@redhat.com>
Date: Fri, 11 May 2007 23:29:08 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pierre Peiffer <pierre.peiffer@bull.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: FUTEX_CMP_REQUEUE_PI is not quite there
References: <46455A67.8040203@redhat.com> <20070511231931.52d963ab.akpm@linux-foundation.org>
In-Reply-To: <20070511231931.52d963ab.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well yup.  We're kind of waiting for someone to reply
> to http://lkml.org/lkml/2007/5/7/129

Seems to be the same or at least related.

On comment about my first mail: this is the correct code of condvars, 
despite what I wrote before.  I wasn't thinking clear.  The internal 
futex is a normal futex.  It is the job of the CMP_REQUEUE_PI call to 
figure this out, select the waiter with the highest priority, and boost 
the priority if necessary based on the targer futex which always is a PI 
futex.

-- 
➧ Ulrich Drepper ➧ Red Hat, Inc. ➧ 444 Castro St ➧ Mountain View, CA ❖
