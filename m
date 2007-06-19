Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbXFSUn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbXFSUn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754174AbXFSUnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:43:19 -0400
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:59109 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754135AbXFSUnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:43:18 -0400
Date: Tue, 19 Jun 2007 16:43:17 -0400
To: Chris Snook <csnook@redhat.com>
Cc: Jack Stone <jack@hawkeye.stone.uk.eu.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com, alan <alan@clueserver.org>
Subject: Re: Versioning file system
Message-ID: <20070619204317.GR10008@csclub.uwaterloo.ca>
References: <46731169.2090002@hawkeye.stone.uk.eu.org> <4673182B.4090800@redhat.com> <46739E89.1080003@hawkeye.stone.uk.eu.org> <46781A5B.9090104@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46781A5B.9090104@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 02:03:07PM -0400, Chris Snook wrote:
> I pointed out NetApp's .snapshot directories because that's a method that 
> uses legal path character, but doesn't break anything.  With this method, 
> userspace tools will have to be taught that : is suddenly a special 
> character.  Userspace already knows that files beginning with . are special 
> and treat them specially. We don't need a new special character for every 
>  new feature.  We've got one, and it's flexible enough to do what you want, 
> as proven by NetApp's extremely successful implementation.  Perhaps you 
> want a slightly different interface from what NetApp has implemented, but 
> what you're suggesting will change the default behavior of basic tools like 
> tar and ls.  This is not a good thing.

I think I used one of those systems once (or at least another one with
.snapshot feature).  It managed to completely avoid user space problems
by never actually showing .snapshot in directory listings, but you could
always cd to it or refer to it explicitly.  You never risked having tar
or find or anything else accidentally pick it up.  Very nice interface.

--
Len Sorensen
