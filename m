Return-Path: <linux-kernel-owner+w=401wt.eu-S1756112AbZELR6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbZELR6Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 13:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbZELR56
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 13:57:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754023AbZELR55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 13:57:57 -0400
Date: Tue, 12 May 2009 10:50:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090512105059.30fb93c2.akpm@linux-foundation.org>
In-Reply-To: <200905121852.37224.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905120128.16780.rjw@sisk.pl>
	<20090511171111.9d74e4c0.akpm@linux-foundation.org>
	<200905121852.37224.rjw@sisk.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 18:52:36 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Well, what about the following?

It has the virtue of simplicity.

> +static inline void disable_oom_killer(void)
> +{
> +	oom_killer_disabled = true;
> +}
> +
> +static inline void enable_oom_killer(void)
> +{
> +	oom_killer_disabled = false;
> +}

I'll change these to oom_killer_disable() and oom_killer_enable(), OK?
