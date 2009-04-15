Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZDOSaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZDOSaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZDOSaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:30:10 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:39792 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbZDOSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:30:09 -0400
Date: Wed, 15 Apr 2009 20:32:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, Ingo Molnar <mingo@elte.hu>
Subject: Re: GFS2: Tracing support for review
Message-ID: <20090415183213.GA26155@uranus.ravnborg.org>
References: <1239810905.29604.60.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239810905.29604.60.camel@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 04:55:05PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> This is my current patch to add tracepoints to GFS2. I couldn't use
> the recommended method of putting the trace_gfs2.h into fs/gfs2/
> because of something strange happening with the macros. The full
> path on my machine was: /home/steve/linux-2.6-tip/fs/gfs2 but
> somehow this was being substituted as: /home/steve/1-2.6-tip/fs/gfs2
> if I used the second method listed here: http://lkml.org/lkml/2009/4/14/578

Most likely because the preprocessor define the symbol "linux" to "1".
In general we should avoid playing games with include paths - it will
bite us.

	Sam
