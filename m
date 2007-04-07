Return-Path: <linux-kernel-owner+w=401wt.eu-S966097AbXDGQsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966097AbXDGQsa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 12:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966100AbXDGQsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 12:48:30 -0400
Received: from waste.org ([66.93.16.53]:60278 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966097AbXDGQs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 12:48:29 -0400
Date: Sat, 7 Apr 2007 11:36:00 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/13] maps#2: Add /proc/pid/pagemap interface
Message-ID: <20070407163600.GN4892@waste.org>
References: <1.469046093@selenic.com> <13.469046093@selenic.com> <20070406235510.66115517.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406235510.66115517.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 11:55:10PM -0700, Andrew Morton wrote:
> On Fri, 06 Apr 2007 17:03:13 -0500 Matt Mackall <mpm@selenic.com> wrote:
> 
> > Add /proc/pid/pagemap interface
> > 
> > This interface provides a mapping for each page in an address space to
> > its physical page frame number, allowing precise determination of what
> > pages are mapped and what pages are shared between processes.
> 
> Could we please have a simple read-proc-pid-pagemap.c placed under
> Documentation/ somewhere?  Also some sample output for the changelog
> so we can see what all this does.

Working on that. The userspace portion of my tools are very rough at
the moment. And in Python.
 
> Also for kpagemap, please.
> 
> Should /proc/pid/pagemap and kpagemap be versioned?

They've both got a variable-sized header, so we can add things there. 

-- 
Mathematics is the supreme nostalgia of our time.
