Return-Path: <linux-kernel-owner+w=401wt.eu-S965513AbXDJNJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965513AbXDJNJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 09:09:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965558AbXDJNJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 09:09:13 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:38935 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965513AbXDJNJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 09:09:12 -0400
Date: Tue, 10 Apr 2007 18:46:42 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 4/7] Containers (V8): Simple CPU accounting container subsystem
Message-ID: <20070410131642.GA3611@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.470037000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407001324.470037000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 04:32:25PM -0700, menage@google.com wrote:
> +struct container_subsys cpuacct_subsys = {
> +	.name = "cpuacct",
> +	.create = cpuacct_create,
> +	.destroy = cpuacct_destroy,
> +	.populate = cpuacct_populate,
> +	.subsys_id = cpuacct_subsys_id,
> +};

container_register_subsys(&cpuacct_subsys) is missing ..

-- 
Regards,
vatsa
