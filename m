Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbZD3D4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbZD3D4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 23:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbZD3D4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 23:56:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbZD3D4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 23:56:43 -0400
Date: Wed, 29 Apr 2009 20:54:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
       Sachin Sant <sachinp@in.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13068] Lockdep warining in inotify_dev_queue_event
Message-Id: <20090429205419.99aaab47.akpm@linux-foundation.org>
In-Reply-To: <200904292340.17071.rjw@sisk.pl>
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera>
	<200904292151.46107.rjw@sisk.pl>
	<49F8C255.2040301@gmail.com>
	<200904292340.17071.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009 23:40:16 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> 
> Since Sachin is no longer able to reproduce it, now you're the reporter. :-)
> 

Wu Fengguang <fengguang.wu@intel.com> is hitting it as well (Subject:
[PATCH] use GFP_NOFS in kernel_event()).

Unless Eric (or Peter) get a wiggle on, we might need to merge the
GFP_NOFS thing.

