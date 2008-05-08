Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbYEHVdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbYEHVdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 17:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbYEHVd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 17:33:28 -0400
Received: from www17.your-server.de ([213.133.104.17]:48138 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYEHVd0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 17:33:26 -0400
Message-ID: <1210282367.48237180564a0@213.133.104.17>
Date: Thu, 08 May 2008 23:32:48 +0200
From: Thomas Meyer <thomas@m3y3r.de>
To: Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org, arges@linux.vnet.ibm.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: BUG: unable to handle kernel paging request at xxx
References: <1210097735.3644.6.camel@dhcppc1>  <4820A482.8000104@sgi.com> <1210102011.3644.12.camel@dhcppc1> <4823525A.8080805@sgi.com>
In-Reply-To: <4823525A.8080805@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 84.59.40.57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zitat von Mike Travis <travis@sgi.com>:

> Thomas Meyer wrote:
> > Am Dienstag, den 06.05.2008, 11:33 -0700 schrieb Mike Travis:
> > 
> >> Would you also send your .config file as well
> >> as a summary of the system configuration (cpu type, etc.)?
> ...
> > $ opcontrol --version
> > opcontrol: oprofile 0.9.3 compiled on Oct  8 2007 10:36:39
> > 
> > $ yum list oprofile
> > Installed Packages
> > oprofile.i386                            0.9.3-6.fc8            installed  
> 
> > 
> 
> Hi Thomas,
> 
> I've not been able to reproduce this failure on my (very similar) AMD
> box.  I've compiled and installed the oprofile package but that didn't
> seem to do it. 
> 
> # opcontrol --version
> opcontrol: oprofile 0.9.3 compiled on May  8 2008 12:02:00
> 
> One thing to note is that I'm using the very latest linux-next source,
> would this be the same as what you are using?

My git tree is currently on tag next-20080508.

> 
> Also I've noticed is that your system is loading SELinux while mine
> is not, though I doubt that has any effect on the panic.
> 
> yours:
> [    0.753301] Security Framework initialized
> [    0.753301] SELinux:  Initializing.
> [    0.753301] SELinux:  Starting in permissive mode
> 
> mine:
> Mount failed for selinuxfs on /selinux:  No such device                      
>       
> 
> (Unfortunately I'm not familiar with that package or I'd pop it in
> to try it out.)
> 
> If you can come up with some more info (or try Andrew's "back out"
> patch to verify that the oprofile changes are the cause of the panic),
> would you let me know?

when i revert commit 608dfddd845da5ab6accef70154c8910529699f7 oprofile doesn't
produce an oops, i.e. works as expected.

> 
> Thanks,
> Mike
> 
> 



