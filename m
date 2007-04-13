Return-Path: <linux-kernel-owner+w=401wt.eu-S1030871AbXDMWjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030871AbXDMWjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 18:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030870AbXDMWjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 18:39:44 -0400
Received: from crown.reflexsecurity.com ([72.54.139.163]:50863 "EHLO
	crown.reflexsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030869AbXDMWjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 18:39:43 -0400
X-Reflex-Keepalives: .
Date: Fri, 13 Apr 2007 18:39:36 -0400
From: Jason Lunz <lunz@falooley.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cameron Schaus <cam@schaus.ca>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.20 OOM with 8Gb RAM
Message-ID: <20070413223935.GA6783@metaxa.reflex>
References: <20070412173830.GA31323@schaus.ca> <20070412121553.c7fd3249.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412121553.c7fd3249.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 12:15:53PM -0700, Andrew Morton wrote:
> All of ZONE_NORMAL got used by ramdisk, and networking wants to
> allocate a page from ZONE_NORMAL.  An oom-killing is the correct
> response, although probably not effective.
> 
> ramdisk is a nasty thing - cannot you use ramfs or tmpfs?

What do you mean by "nasty thing"? I've heard that about loopback too.

If I want to run a system entirely from ram with a compressed filesystem
image mounted on /, is it better to store that image in a ramdisk, or on
a tmpfs and mount it via loopback?

Jason
