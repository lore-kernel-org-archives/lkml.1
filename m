Return-Path: <linux-kernel-owner+w=401wt.eu-S1751525AbZH1QUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbZH1QUl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:20:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305AbZH1QUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10011 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZH1QUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:20:40 -0400
Subject: Re: Linux-2.6.31-rc8 inotify hangs samba clients
From: Eric Paris <eparis@redhat.com>
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0908282358560.19623@boston.corp.fedex.com>
References: <Pine.LNX.4.64.0908282358560.19623@boston.corp.fedex.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 12:20:22 -0400
Message-Id: <1251476422.28787.1.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-29 at 00:13 +0800, Jeff Chua wrote:
> 
> The first part of commit 0db501bd0610ee0c0aca84d927f90bcccd09e2bd hangs 
> WinXP clients browsing Linux samba folders ... trying to add a 
> terminating byte to name_len. Reverting this solves the problem.
> 
> The second part of adding zeros is fine.
> 
> If we don't revert here, then Samba 3.3.7 will have to change to work with 
> Linux 2.6.31-rc8, and perhaps other codes as well.

Deffinitly not Samba's fault.  I should have 2 patches to fix inotify
at:

http://git.infradead.org/users/eparis/notify.git/shortlog/refs/heads/for-linus

-Eric

