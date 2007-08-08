Return-Path: <linux-kernel-owner+w=401wt.eu-S1765381AbXHHHuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765381AbXHHHuM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756666AbXHHHt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:49:59 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59612 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbXHHHt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:49:57 -0400
Date: Wed, 8 Aug 2007 16:51:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>
Subject: Re: [-mm PATCH 0/9] Memory controller introduction (v4)
Message-Id: <20070808165131.b4ab4e92.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070808125139.7cfe702c.kamezawa.hiroyu@jp.fujitsu.com>
References: <20070727200937.31565.78623.sendpatchset@balbir-laptop>
	<20070808125139.7cfe702c.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 12:51:39 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Sat, 28 Jul 2007 01:39:37 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > At OLS, the resource management BOF, it was discussed that we need to manage
> > RSS and unmapped page cache together. This patchset is a step towards that
> > 
> Can I make a question ? Why limiting RSS instead of # of used pages per
> container ? Maybe bacause of shared pages between container.... 
Sorry....Ignore above question.
I didn't understand what mem_container_charge() accounts and limits.
It controls # of meta_pages.

Sorry,
-Kame

