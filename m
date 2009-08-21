Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbZHUGZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbZHUGZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 02:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbZHUGZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 02:25:35 -0400
Received: from smarthost03.mail.zen.net.uk ([212.23.3.142]:41085 "EHLO
	smarthost03.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067AbZHUGZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 02:25:35 -0400
Date: Fri, 21 Aug 2009 07:25:16 +0100
From: Grant Wilson <grant.wilson@zen.co.uk>
To: Eric Paris <eparis@parisplace.org>
Cc: aviro@redhat.com, lkml <linux-kernel@vger.kernel.org>, eparis@redhat.com
Subject: Re: 2.6.31-rc6: Oops in fsnotify
Message-ID: <20090821072516.0ac7bbab@worthy.swandive.local>
In-Reply-To: <7e0fb38c0908201922r6f9598f9ja95623ea6cf11254@mail.gmail.com>
References: <20090820164818.6039c185@worthy.swandive.local>
	<7e0fb38c0908201922r6f9598f9ja95623ea6cf11254@mail.gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost03-IP: [82.71.45.175]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009 22:22:34 -0400
Eric Paris <eparis@parisplace.org> wrote:

> I'll take a close look in the morning.  I don't offhand see how this
> is possible without calling vfs_unlink on a negative dentry (does that
> even make sense?)
> 
> What was the filesystem you are dealing with?  Odd, very, odd (as with
> all the problems people find in my notify code)
> 
The filesystem is ext4 (converted from ext3).

Grant
