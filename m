Return-Path: <linux-kernel-owner+w=401wt.eu-S1755397AbZBXBtT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397AbZBXBtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 20:49:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZBXBtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 20:49:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42723 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZBXBtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 20:49:09 -0500
Date: Tue, 24 Feb 2009 10:47:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       menage@google.com, containers@lists.linux-foundation.org
Subject: Re: Question for remount
Message-Id: <20090224104751.4767a3a1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A35048.3000304@cn.fujitsu.com>
References: <20090220190223.e8b4f6a8.kamezawa.hiroyu@jp.fujitsu.com>
	<49A20976.2050301@cn.fujitsu.com>
	<49A21044.40402@cn.fujitsu.com>
	<20090224103659.069e6b33.kamezawa.hiroyu@jp.fujitsu.com>
	<49A35048.3000304@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Feb 2009 09:41:28 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >>  To change the set of subsystems bound to a mounted hierarchy, just
> >>  remount with different options:
> >> +# mount -o remount,cpuset,ns hier1 /dev/cgroup
> >>  
> >> -# mount -o remount,cpuset,ns  /dev/cgroup
> >> +Now numtasks is removed from the hierarchy and ns is added.
> >> +
> >> +Note this will add ns to the hierarchy but won't remove numtasks or
> >> +cpuset:
> >> +# mount -o remount,ns /dev/cgroup
> >>  
> > 
> > Just a question. What is "numtasks" here ? We have numtasks cgroup ?
> > 
> 
> No, I guess that's a proposed but not implemented cgroup subsystem. :)
> And I can change it to an existing one.
> 
O.K. thanks.

BTW, how about writing this kind of text in explicit way ?
+Note: this will add ns to the hierarchy but won't remove numtasks or
+cpuset because new options is appended to old options. If you want to
+override, please use.....

-Kame

