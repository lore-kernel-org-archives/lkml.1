Return-Path: <linux-kernel-owner+w=401wt.eu-S1752194AbXE3HkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194AbXE3HkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 03:40:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXE3Hj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 03:39:56 -0400
Received: from holomorphy.com ([66.93.40.71]:50772 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbXE3Hj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 03:39:56 -0400
Date: Wed, 30 May 2007 00:39:59 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: menage@google.com, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070530073959.GC6909@holomorphy.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070530001455.45cf1dc5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530001455.45cf1dc5.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2007 at 12:14:55AM -0700, Andrew Morton wrote:
> So how do we do this?
> Is there any sneaky way in which we can modify the kernel so that this new
> code gets exercised more?  Obviously, tossing init into some default
> system-wide container would be a start.  But I wonder if we can be
> sneakier - for example, create a new container on each setuid(), toss the
> task into that.  Or something along those lines?

How about a container for each thread group, pgrp, session, and user?


-- wli
