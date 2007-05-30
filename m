Return-Path: <linux-kernel-owner+w=401wt.eu-S1751346AbXE3HR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751346AbXE3HR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752079AbXE3HRS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:17:18 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:57107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751512AbXE3HRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:17:17 -0400
Date: Wed, 30 May 2007 00:15:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 01/10] Containers(V10): Basic container framework
Message-Id: <20070530001502.d988f8d6.akpm@linux-foundation.org>
In-Reply-To: <20070529132142.052411000@menage.corp.google.com>
References: <20070529130104.461765000@menage.corp.google.com>
	<20070529132142.052411000@menage.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 06:01:05 -0700 menage@google.com wrote:

> +For example, the following sequence of commands will setup a container
> +named "Charlie", containing just CPUs 2 and 3, and Memory Node 1,
> +and then start a subshell 'sh' in that container:
> +
> +  mount -t container cpuset -ocpuset /dev/container
> +  cd /dev/container
> +  mkdir Charlie
> +  cd Charlie
> +  /bin/echo $$ > tasks
> +  sh
> +  # The subshell 'sh' is now running in container Charlie
> +  # The next line should display '/Charlie'
> +  cat /proc/self/container

Once this has been done, can tasks inside `Charlie' escape from it?

And what permissions are needed to expand the various allotments (if
that's the approved term) for `Charlie'?
