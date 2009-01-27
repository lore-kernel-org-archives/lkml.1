Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZA0JbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZA0JbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 04:31:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbZA0JbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 04:31:16 -0500
Received: from matrixpower.ru ([195.178.208.66]:45935 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703AbZA0JbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 04:31:15 -0500
Date: Tue, 27 Jan 2009 12:31:05 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, balbir@linux.vnet.ibm.com,
       Nikanth Karthikesan <knikanth@suse.de>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Torvalds <torvalds@linux-foundation.org>,
       Arve Hj?nnev?g <arve@android.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Snook <csnook@redhat.com>, Paul Menage <menage@google.com>
Subject: Re: [RFC] [PATCH] Cgroup based OOM killer controller
Message-ID: <20090127093105.GB2646@ioremap.net>
References: <20090127155825.D476.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262325320.13157@chino.kir.corp.google.com> <20090127164238.D479.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0901262350110.14525@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2009 at 11:51:27PM -0800, David Rientjes (rientjes@google.com) wrote:
> Yeah, I proposed /dev/mem_notify being made as a client of cgroups there 
> in http://marc.info/?l=linux-kernel&m=123200623628685
> 
> How do you replace the oom killer's capability of giving a killed task 
> access to memory reserves with TIF_MEMDIE in userspace?

/dev/mem_notify is a great idea, but please do not limit existing
oom-killer in its ability to do the job and do not rely on application's
ability to send a SIGKILL which will not kill tasks in unkillable state
contrary to oom-killer.

-- 
	Evgeniy Polyakov
