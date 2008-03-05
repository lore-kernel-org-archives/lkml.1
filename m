Return-Path: <linux-kernel-owner+w=401wt.eu-S1756195AbYCESKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbYCESKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 13:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYCESKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 13:10:31 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41036 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbYCESKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 13:10:30 -0500
Date: Wed, 5 Mar 2008 10:10:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Jackson <pj@sgi.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] Cpuset hardwall flag:  Introduction
Message-Id: <20080305101015.cdff44f2.akpm@linux-foundation.org>
In-Reply-To: <20080305062318.3c7538c3.pj@sgi.com>
References: <20080305075237.608599000@menage.corp.google.com>
	<20080305062318.3c7538c3.pj@sgi.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008 06:23:18 -0600 Paul Jackson <pj@sgi.com> wrote:

> Paul M wrote:
> > Currently the cpusets mem_exclusive flag is overloaded to mean both
> > "no-overlapping" and "no GFP_KERNEL allocations outside this cpuset".
> > 
> > These patches add a new mem_hardwall flag with just the allocation
> > restriction part of the mem_exclusive semantics, without breaking
> > backwards-compatibility for those who continue to use just
> > mem_exclusive.
> 
> ... too bad this nice comment wasn't included in PATCH 2/2, so that
> it would automatically make it into the record of history - the source
> control log message (as best I understand how Andrew's tools work,
> comments off in their own, codeless patch "PATCH 0/N" don't make
> it to the source control log, except when Andrew chooses to make a
> special effort.)

I make that special effort almost 100% of the time.  The changelog for the
first patch becomes:


<text from [0/n]>

This patch:

<text from [1/n]>
