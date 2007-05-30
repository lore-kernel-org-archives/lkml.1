Return-Path: <linux-kernel-owner+w=401wt.eu-S1752206AbXE3HRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206AbXE3HRB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXE3HQx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:16:53 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:34678 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291AbXE3HQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:16:52 -0400
Date: Wed, 30 May 2007 00:14:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: menage@google.com
Cc: dev@sw.ru, xemul@sw.ru, serue@us.ibm.com, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-Id: <20070530001455.45cf1dc5.akpm@linux-foundation.org>
In-Reply-To: <20070529130104.461765000@menage.corp.google.com>
References: <20070529130104.461765000@menage.corp.google.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2007 06:01:04 -0700 menage@google.com wrote:

> This is an update to my multi-hierarchy multi-subsystem generic
> process containers patch.
> 
> ...
> 
> Still TODO:
> 
> ...
>
> - lots more testing
> 

So how do we do this?

Is there any sneaky way in which we can modify the kernel so that this new
code gets exercised more?  Obviously, tossing init into some default
system-wide container would be a start.  But I wonder if we can be
sneakier - for example, create a new container on each setuid(), toss the
task into that.  Or something along those lines?
