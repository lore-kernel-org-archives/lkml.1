Return-Path: <linux-kernel-owner+w=401wt.eu-S933211AbXG0Fbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211AbXG0Fbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 01:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbXG0FbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 01:31:23 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:36744 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755275AbXG0FbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 01:31:22 -0400
To: menage@google.com
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, rohitseth@google.com
Subject: Re: [PATCH 01/10] Task Containers(V11): Basic task container
 framework
In-Reply-To: Your message of "Fri, 20 Jul 2007 11:31:53 -0700"
	<20070720191247.388947000@menage.corp.google.com>
References: <20070720191247.388947000@menage.corp.google.com>
X-Mailer: Cue version 0.8 (070404-1613/takashi)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Message-Id: <20070727053120.2EFAC1BF6B8@siro.lan>
Date: Fri, 27 Jul 2007 14:31:19 +0900 (JST)
From: yamamoto@valinux.co.jp (YAMAMOTO Takashi)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +Other fields in the container_subsys object include:

> +- hierarchy: an index indicating which hierarchy, if any, this
> +  subsystem is currently attached to. If this is -1, then the
> +  subsystem is not attached to any hierarchy, and all tasks should be
> +  considered to be members of the subsystem's top_container. It should
> +  be initialized to -1.

stale info?

> +struct container {

> +	struct containerfs_root *root;
> +	struct container *top_container;
> +};

can cont->top_container be different from than &cont->root.top_container?

YAMAMOTO Takashi
