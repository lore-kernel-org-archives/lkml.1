Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYLPBCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYLPBCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 20:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751301AbYLPBCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 20:02:46 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36976 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbYLPBCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 20:02:45 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 2/3] fsnotify: sys_execve and sys_uselib do not call into fsnotify
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       hch@infradead.org, akpm@linux-foundation.org
In-Reply-To: <20081215164414.2018.66642.stgit@paris.rdu.redhat.com>
References: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com> <20081215164414.2018.66642.stgit@paris.rdu.redhat.com>
Message-Id: <20081216100209.06CA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Tue, 16 Dec 2008 10:02:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> sys_execve and sys_uselib do not call into fsnotify so inotify and dnotify do
> not see opens on things which are going to be exectued.  This patch creates a
> generic fsnotify hook for these operations
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>

looks good to me.
	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



