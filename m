Return-Path: <linux-kernel-owner+w=401wt.eu-S1750930AbXBLMdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750930AbXBLMdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 07:33:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964892AbXBLMdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 07:33:45 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38084 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXBLMdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 07:33:44 -0500
Date: Mon, 12 Feb 2007 18:03:09 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       rohitseth@google.com, mbligh@google.com, winget@google.com,
       containers@lists.osdl.org, devel@openvz.org
Subject: Re: [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070212123309.GA7526@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.130746000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:22AM -0800, menage@google.com wrote:
> +void container_fork(struct task_struct *child)
> +{
> +	task_lock(current);

Can't this be just rcu_read_lock()?

> +	child->container = current->container;
> +	atomic_inc(&child->container->count);
> +	task_unlock(current);
> +}

-- 
Regards,
vatsa
