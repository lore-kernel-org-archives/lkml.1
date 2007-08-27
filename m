Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbXH0I0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbXH0I0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 04:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXH0I0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 04:26:37 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:42616 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752044AbXH0I0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 04:26:36 -0400
To: balbir@linux.vnet.ibm.com
Cc: akpm@linux-foundation.org, npiggin@suse.de, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, ebiederm@xmission.com, containers@lists.osdl.org,
       menage@google.com, xemul@openvz.org
Subject: Re: [-mm PATCH 5/10] Memory controller task migration (v7)
In-Reply-To: Your message of "Fri, 24 Aug 2007 20:50:43 +0530"
	<20070824152043.16582.37727.sendpatchset@balbir-laptop>
References: <20070824152043.16582.37727.sendpatchset@balbir-laptop>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070827082635.195471BFA2C@siro.lan>
Date: Mon, 27 Aug 2007 17:26:35 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Allow tasks to migrate from one container to the other. We migrate
> mm_struct's mem_container only when the thread group id migrates.

> +	/*
> +	 * Only thread group leaders are allowed to migrate, the mm_struct is
> +	 * in effect owned by the leader
> +	 */
> +	if (p->tgid != p->pid)
> +		goto out;

does it mean that you can't move a process between containers
once its thread group leader exited?

YAMAMOTO Takashi
