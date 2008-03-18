Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbYCRLul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbYCRLul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 07:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYCRLue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 07:50:34 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51724 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbYCRLud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 07:50:33 -0400
Date: Tue, 18 Mar 2008 20:55:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 2/4] Block I/O tracking
Message-Id: <20080318205501.59877972.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080318.203422.45236787.taka@valinux.co.jp>
References: <20080318.182251.93858044.taka@valinux.co.jp>
	<20080318.182906.104806991.taka@valinux.co.jp>
	<20080318192233.89c5cc3e.kamezawa.hiroyu@jp.fujitsu.com>
	<20080318.203422.45236787.taka@valinux.co.jp>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Mar 2008 20:34:22 +0900 (JST)
Hirokazu Takahashi <taka@valinux.co.jp> wrote:

>
> > And, blist seems to be just used for force_empty.
> > Do you really need this ? no alternative ?
> 
> I selected this approach because it was the simplest way for the
> first implementation.
> 
> I've been also thinking about what you pointed.
> If you don't mind taking a long time to remove a bio cgroup, it will be
> the easiest way that you can scan all pages to find the pages which
> belong to the cgroup and delete them. It may be enough since you may
> say it will rarely happen. But it might cause some trouble on machines
> with huge memory.
> 
Hmm, force_empty itself is necessary ?

Thanks,
-Kame

