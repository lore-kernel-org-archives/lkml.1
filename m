Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758320Ab0AOVZe (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196Ab0AOVZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:25:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758106Ab0AOVZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:25:33 -0500
Date: Fri, 15 Jan 2010 13:24:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, miltonm@austin.ibm.com,
        penberg@cs.helsinki.fi, bharata@linux.vnet.ibm.com, jkosina@suse.cz
Subject: Re: [PATCH] idr: fix idr corruption when id crosses a layer
 boundary
Message-Id: <20100115132432.88037419.akpm@linux-foundation.org>
In-Reply-To: <1263590090-24967-1-git-send-email-eparis@redhat.com>
References: <1263590090-24967-1-git-send-email-eparis@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jan 2010 16:14:50 -0500
Eric Paris <eparis@redhat.com> wrote:

> inotify has for months been been having problems keeping the fsnotify view of
> its objects in sync with the idr view of its objects.  I discovered this was
> only ever the case with the 4096th object created.

Neato.  Do you think this will help with all the inotify problems
people have been having?

Do you think this fix should go into 2.6.32.x and earlier?

Thanks.
