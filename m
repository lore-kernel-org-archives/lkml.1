Return-Path: <linux-kernel-owner+w=401wt.eu-S1753088AbZIILyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbZIILyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZIILyC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:54:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54946 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbZIILyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:54:00 -0400
Subject: Re: [PATCH 1/1] sched: fix cpu_down deadlock
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: rjw@sisk.pl, laijs@cn.fujitsu.com, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1252496510-11898-1-git-send-email-jirislaby@gmail.com>
References: <4AA0FEBF.7040104@gmail.com>
	 <1252496510-11898-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 13:53:45 +0200
Message-Id: <1252497225.7235.3.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-09 at 13:41 +0200, Jiri Slaby wrote:
> Jiri Slaby wrote:
> > Thanks, in the end I found it manually. Goddammit! It's an -mm thing:
> > cpu_hotplug-dont-affect-current-tasks-affinity.patch

Is there a git tree with -mm in some place? I can't seem to find that
patch in my inbox.

All I can find is some comments from Oleg that the patch looks funny.

