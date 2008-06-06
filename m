Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbYFFBzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbYFFBzB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 21:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYFFByv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 21:54:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44995 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbYFFByv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 21:54:51 -0400
Date: Fri, 6 Jun 2008 10:55:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: clean up checking of  the disabled flag
Message-Id: <20080606105535.de04c038.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4848955D.2020302@cn.fujitsu.com>
References: <4848955D.2020302@cn.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 09:39:41 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Those checks are unnecessary, because when the subsystem is disabled
> it can't be mounted, so those functions won't get called.
> 
> The check is needed in functions which will be called in other places
> except cgroup.
> 
Good catch!

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


