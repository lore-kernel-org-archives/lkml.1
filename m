Return-Path: <linux-kernel-owner+w=401wt.eu-S1752657AbXLVKSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbXLVKSh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 05:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbXLVKS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 05:18:29 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbXLVKS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 05:18:28 -0500
Subject: Re: [PATCH] kthread: run kthreadd with max priority SCHED_FIFO
From: Jon Masters <jcm@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Schmidt <mschmidt@redhat.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <20071222021135.68becd45.akpm@linux-foundation.org>
References: <20071217234314.540b59bd@hammerfall>
	 <20071222013021.db2528cb.akpm@linux-foundation.org>
	 <1198317171.24423.47.camel@perihelion>
	 <20071222021135.68becd45.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Sat, 22 Dec 2007 05:18:16 -0500
Message-Id: <1198318696.24423.64.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-12-22 at 02:11 -0800, Andrew Morton wrote:

> Should there be a watchdog which checks for a process which has run
> realtime for a certain period and which then takes some action?  Such as
> descheduling it for a while, generating warnings, demoting its policy,
> killing it etc?

Using the analogy of the OOM killer being called, this wouldn't be a bad
idea IMO - especially if it were configurable, and off by default. This
couldn't be done in a kernel thread (unless some new priority level were
created for it), but I think the details can be worked out later.

Michal - what do you think is the best upstream solution?

Jon.


