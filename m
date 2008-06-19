Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbYFSDNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbYFSDNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 23:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYFSDNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 23:13:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54069 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbYFSDNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 23:13:47 -0400
Date: Thu, 19 Jun 2008 12:17:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Jackson <pj@sgi.com>
Subject: Re: [RFC] [PATCH] cgroup: add "procs" control file
Message-Id: <20080619121710.d6834a43.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4859CD62.8090402@cn.fujitsu.com>
References: <4858C111.8050806@cn.fujitsu.com>
	<20080619091436.0a441351.kamezawa.hiroyu@jp.fujitsu.com>
	<4859CD62.8090402@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2008 11:07:14 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> > So, how about this kind of interface ? showing both of TID and PID.
> > 
> > %/cat/procs
> > TID  PID
> > 1001 1001
> > 1234 1001
> > 3856 1001
> > 728  728
> > ....
> > ....
> > 
> > nonsense ?
> > 
> 
> Then the left column is exactly the same with the contents of `cat tasks`, so IMO
> it won't be useful. Besides, the tasks of pids listed in the right column may not
> all belongs to that group, so how we can make use of this column?
> 
Then, how useful /procs is ;)  it's of-no-use.

Thanks,
-Kame

