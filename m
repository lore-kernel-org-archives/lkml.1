Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbZEKBru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbZEKBru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 21:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZEKBrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 21:47:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34661 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbZEKBrk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 21:47:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch 06/11 -mmotm] oom: move oom_adj value from task_struct to mm_struct
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Mel Gorman <mel@csn.ul.ie>, Peter Ziljstra <a.p.ziljstra@chello.nl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>, San Mehat <san@android.com>,
       Arve Hjonnevag <arve@android.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.0905101724400.31823@chino.kir.corp.google.com>
References: <20090511091640.B9B5.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.0905101724400.31823@chino.kir.corp.google.com>
Message-Id: <20090511103849.B9BE.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 11 May 2009 10:47:38 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > David, staging driver shold be standalone.
> > Please don't change core kernel for staging.
> > 
> > if you merge it into mainline, I suggest to you help the driver graduate
> > staging.
> > 
> 
> Umm, all my patches apply fine against mainline since the Android 
> lowmemorykiller is already in Linus' tree.  This patch moves oomkilladj 
> from struct task_struct to struct mm_struct and since that's used for 
> procfs, the oom killer, and the Android lowmemorykiller, I need to modify 
> all of them so the kernel will compile with 
> CONFIG_ANDROID_LOW_MEMORY_KILLER.

>From technical view, your explanation seems good although I haven't
review your patch.
but this patch break staging driver rule. I don't like it.

IOW, if greg pull this patch into his staging tree, it might make
patch conflict against -mm tree in nearly future.



