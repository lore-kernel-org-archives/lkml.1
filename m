Return-Path: <linux-kernel-owner+w=401wt.eu-S1753060AbZIKLRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbZIKLRW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbZIKLRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:17:22 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51944 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbZIKLRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:17:21 -0400
Date: Fri, 11 Sep 2009 16:46:32 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org,
       xen-devel@lists.xensource.com, ioband-devel@lists.sourceforge.net,
       corsetproject@googlegroups.com, kunai@linux-foundation.jp,
       osonoi@linux-foundation.jp, Balbir Singh <balbir@in.ibm.com>,
       vgoyal@redhat.com
Subject: Re: IO controller Mini-Summit 2009
Message-ID: <20090911111632.GF4474@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20090826.203251.260094379.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826.203251.260094379.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 08:32:51PM +0900, Ryo Tsuruta wrote:
> Hi All,
> 
> As I have notified before, The 1st Linux IO controller Mini-Summit
> will be held in Tokyo Japan on Oct 17 -- day before the 9th Linux
> kernel summit. So I would like to propose the following topics for 
> the mini-summit and discuss about them.
> 
> - Multiple IO controller development projects
>   - There are two activities for the development of IO controller,
>     Vivek's io-controller and dm-ioband. Do we have to pick one of
>     them to put into the mainline? How to advance the development?
> 
> - Extensions of struct bio
>   - Make a bio point to the io_context of a process which creates the
>     I/O request. This allows to pass the IO scheduling class and
>     priority information to IO controller even if the IO is submitted
>     by another process which does not create the request, such as a
>     worker thread.
>   - Add a new flag to struct bio to identify the bio as urgent. This
>     gives IO controller a chance to handle the bio as high priority.
>     This flag should be set if the bio is created for the page-out
>     operation.
> 
> - I/O tracking and charging policy
>   - Which process, a page-requesting process or a page-returning
>     process, should be charged for the I/O caused by page reclaim?
>     We should consider two cases where the IO flushes anonymous pages
>     and file mapped pages.
> 
> I think this is a good opportunity to meet face-to-face to discuss
> about IO controller development. I would like to many developers to
> join this mini-summit. Please visit the following URL for more
> information about the mini-summit.
> http://apps.sourceforge.net/trac/ioband/wiki/iosummit
> If you would like to join the mini-summit, please e-mail to me or post
> on the wiki page, 
> (You need an account on SourceForge.net to edit the wiki page.)
> 
> All comments, questions, suggestions and anything else are appreciated.
> 

Hi Ryo,

Would you be having a remote dial-in for folks who cannot attend in
person?

thanks,
-- 
regards,
Dhaval
