Return-Path: <linux-kernel-owner+w=401wt.eu-S1760670AbZEKXN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760670AbZEKXN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754347AbZEKXNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:13:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40220 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752007AbZEKXNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:13:46 -0400
Date: Mon, 11 May 2009 16:07:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: rientjes@google.com, fengguang.wu@intel.com,
       linux-pm@lists.linux-foundation.org, pavel@ucw.cz,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [PATCH 1/5] mm: Add __GFP_NO_OOM_KILL flag
Message-Id: <20090511160704.e1fa2512.akpm@linux-foundation.org>
In-Reply-To: <200905120044.37342.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<200905100103.23815.rjw@sisk.pl>
	<alpine.DEB.2.00.0905111249170.23739@chino.kir.corp.google.com>
	<200905120044.37342.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 May 2009 00:44:36 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Which means this patch:
> http://marc.info/?l=linux-kernel&m=124165031723627 (it also is my favourite
> one).

ho hum, I could live with that ;)

Would it make sense to turn it into something more general?  Instead of
"tasks_frozen/processes_are_frozen()", present it as
"oom_killer_disabled/oom_killer_is_disabled()"?

That would invite other subsystems to use it, if they want to.  Which
might well be a bad thing on their behalf, hard to say..


