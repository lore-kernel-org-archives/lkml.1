Return-Path: <linux-kernel-owner+w=401wt.eu-S1765912AbYDOU7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765912AbYDOU7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbYDOU6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:58:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYDOU6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:58:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Li Zefan <lizf@cn.fujitsu.com>, balbir@linux.vnet.ibm.com,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: kernel warning: tried to kill an mm-less task!
In-Reply-To: Oleg Nesterov's message of  Tuesday, 15 April 2008 10:17:16 +0400 <20080415061716.GA89@tv-sign.ru>
References: <4803030D.3070906@cn.fujitsu.com>
	<48030F69.7040801@linux.vnet.ibm.com>
	<48031090.5050002@cn.fujitsu.com>
	<48042539.8050009@cn.fujitsu.com>
	<20080415061716.GA89@tv-sign.ru>
X-Windows: it was hard to write; it should be hard to use.
Message-Id: <20080415205830.2BA4B26FA5E@magilla.localdomain>
Date: Tue, 15 Apr 2008 13:58:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Roland, what do you think about the coredump? Looks like we have the ancient
> bug, zap_threads() can hit the kernel thread.

I think you're right.  But I've never known much about the ->mm maintenance
code or the aio use_mm logic.  So I'm just going from a quick glance.
(That part of the zap_threads() logic predates you or I fiddling with it.)


Thanks,
Roland
