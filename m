Return-Path: <linux-kernel-owner+w=401wt.eu-S1762101AbXHAAmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762101AbXHAAmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756045AbXHAAmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:42:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51379 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756037AbXHAAmJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:42:09 -0400
Date: Tue, 31 Jul 2007 17:41:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
Cc: trelane@digitasaru.net, Al Viro <viro@ftp.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: inotify and /proc/<pid>
Message-Id: <20070731174120.51c49b06.akpm@linux-foundation.org>
In-Reply-To: <20070731203149.eb8babb1.diegocg@gmail.com>
References: <20070731021615.GB6812@digitasaru.net>
	<20070731031720.GF21089@ftp.linux.org.uk>
	<20070731032521.GD6812@digitasaru.net>
	<20070731203149.eb8babb1.diegocg@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 20:31:49 +0200 Diego Calleja <diegocg@gmail.com> wrote:

> El Mon, 30 Jul 2007 22:25:21 -0500, Joseph Pingenot <trelane@digitasaru.net> escribió:
> 
> > More background, please?
> > 
> > What's the way to check for a process exiting without spinning?
> 
> 
> I don't know if it's useful for you, but CONFIG_CONNECTOR and CONFIG_PROC_EVENTS
> will report process creation/exit/fork/etc through a netlink interface.

yup.  See example code in Documentation/accounting/getdelays.c
