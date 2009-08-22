Return-Path: <linux-kernel-owner+w=401wt.eu-S1755831AbZHVRLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831AbZHVRLm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 13:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754943AbZHVRLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 13:11:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbZHVRLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 13:11:41 -0400
Subject: Re: 2.6.31-rc6: Oops in fsnotify
From: Eric Paris <eparis@redhat.com>
To: Grant Wilson <grant.wilson@zen.co.uk>
Cc: Eric Paris <eparis@parisplace.org>, aviro@redhat.com,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20090821072516.0ac7bbab@worthy.swandive.local>
References: <20090820164818.6039c185@worthy.swandive.local>
	 <7e0fb38c0908201922r6f9598f9ja95623ea6cf11254@mail.gmail.com>
	 <20090821072516.0ac7bbab@worthy.swandive.local>
Content-Type: text/plain
Date: Sat, 22 Aug 2009 13:11:38 -0400
Message-Id: <1250961098.3126.1.camel@dhcp231-142.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 07:25 +0100, Grant Wilson wrote:
> On Thu, 20 Aug 2009 22:22:34 -0400
> Eric Paris <eparis@parisplace.org> wrote:
> 
> > I'll take a close look in the morning.  I don't offhand see how this
> > is possible without calling vfs_unlink on a negative dentry (does that
> > even make sense?)
> > 
> > What was the filesystem you are dealing with?  Odd, very, odd (as with
> > all the problems people find in my notify code)

Do you still have the vmlinux file you built?  Would you mind sending it
to me along with your .config?  It's actualy quite normal to get a
negative dentry down in that code and it shouldn't cause a problem.  I
don't see any likely candidates about would like to try to figure out
exactly where in fsnotify it hit that NULL....

-Eric

