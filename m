Return-Path: <linux-kernel-owner+w=401wt.eu-S932510AbYFFVCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510AbYFFVCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 17:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbYFFVCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 17:02:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752459AbYFFVCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 17:02:43 -0400
Date: Fri, 6 Jun 2008 14:02:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 00/25] VM pageout scalability improvements (V10)
Message-Id: <20080606140216.f4520f40.akpm@linux-foundation.org>
In-Reply-To: <20080606202838.390050172@redhat.com>
References: <20080606202838.390050172@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:38 -0400
Rik van Riel <riel@redhat.com> wrote:

> On large memory systems, the VM can spend way too much time scanning
> through pages that it cannot (or should not) evict from memory. Not
> only does it use up CPU time, but it also provokes lock contention
> and can leave large systems under memory presure in a catatonic state.
> 
> Against 2.6.26-rc2-mm1
> 
> This patch series improves VM scalability by:

-mm has a patch called
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
which has been sitting there for some time waiting for us to work out
whether or not it is a desirable thing.

This patchset of yours apparently retains the change which
vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
makes.

But do we know that it was a good one?
