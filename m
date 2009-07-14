Return-Path: <linux-kernel-owner+w=401wt.eu-S1753424AbZGNDz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbZGNDz3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753350AbZGNDz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:55:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46116 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbZGNDz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:55:28 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 14 Jul 2009 12:53:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, serue@us.ibm.com
Subject: Re: [PATCH 3/3] Quick vmalloc vs kmalloc fix to the case where
 array  size is too large
Message-Id: <20090714125334.b476aa78.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
References: <20090710230043.16778.29656.stgit@hastromil.mtv.corp.google.com>
	<20090710230205.16778.11707.stgit@hastromil.mtv.corp.google.com>
	<4A5AA3E7.9070800@cn.fujitsu.com>
	<20090713150303.70ab5176.kamezawa.hiroyu@jp.fujitsu.com>
	<2f86c2480907130827u7d2b062bw26bbb80a8e3de657@mail.gmail.com>
	<20090714084950.2401d9a6.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830907132050n226aecb3ucab6746a4d0e81fa@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jul 2009 20:50:33 -0700
Paul Menage <menage@google.com> wrote:

> On Mon, Jul 13, 2009 at 4:49 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > IIUC, this place, .../procs interface is not so important for performance
> > as to being allowed this ugly conding.
> >
> 
> It's not just the calling thread that suffers from the overhead -
> we've seen performance hits on other processes on a machine due to the
> TLB-shootdown overhead associated with vmalloc()/vfree().
> 
Hmm, ok...then, if too much pids, you hit vmalloc()/vfree() problem again.
So, it's not good idea to use vmalloc/vfree here after all.

Thanks,
-Kame

