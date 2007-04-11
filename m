Return-Path: <linux-kernel-owner+w=401wt.eu-S1161173AbXDKEj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161173AbXDKEj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161186AbXDKEj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:39:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42662 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161173AbXDKEj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:39:57 -0400
Date: Wed, 11 Apr 2007 10:17:17 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Message-ID: <20070411044717.GA15786@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.271959000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407001324.271959000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 04:32:24PM -0700, menage@google.com wrote:
> -int cpuset_create(struct container *cont)
> +int cpuset_create(struct container_subsys *ss, struct container *cont)

Minor nit: The static declaration for cpuset_create (and friends) can be
re-introduced, since they won't be accessed directly from other files?

-- 
Regards,
vatsa
