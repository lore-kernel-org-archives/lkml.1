Return-Path: <linux-kernel-owner+w=401wt.eu-S1763481AbYDOB1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763481AbYDOB1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 21:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757615AbYDOB04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 21:26:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38884 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbYDOB0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 21:26:55 -0400
Date: Tue, 15 Apr 2008 10:31:10 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Pavel Emelianov <xemul@openvz.org>,
       Hugh Dickins <hugh@veritas.com>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm] Add an owner to the mm_struct (v9)
Message-Id: <20080415103110.049e7fd9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080410091602.4472.32172.sendpatchset@localhost.localdomain>
References: <20080410091602.4472.32172.sendpatchset@localhost.localdomain>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2008 14:46:02 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:


> After the thread group leader exits, it's moved to init_css_state by
> cgroup_exit(), thus all future charges from runnings threads would
> be redirected to the init_css_set's subsystem.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Seems works well under my test. 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

