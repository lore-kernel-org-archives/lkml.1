Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbYFGGt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbYFGGt6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 02:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYFGGtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 02:49:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57606 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485AbYFGGtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 02:49:50 -0400
Date: Sat, 07 Jun 2008 15:47:17 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] memcg: clean up checking of  the disabled flag
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <4848955D.2020302@cn.fujitsu.com>
References: <4848955D.2020302@cn.fujitsu.com>
Message-Id: <20080607154422.9C61.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Those checks are unnecessary, because when the subsystem is disabled
> it can't be mounted, so those functions won't get called.
> 
> The check is needed in functions which will be called in other places
> except cgroup.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

nice.
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



