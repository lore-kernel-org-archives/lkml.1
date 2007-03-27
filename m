Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbXC0Ip2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbXC0Ip2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 04:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXC0Ip2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 04:45:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51985 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753366AbXC0Ip1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 04:45:27 -0400
Date: Tue, 27 Mar 2007 01:45:24 -0700
From: Paul Jackson <pj@sgi.com>
To: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: balbir@in.ibm.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-Id: <20070327014524.e4177467.pj@sgi.com>
In-Reply-To: <20070327023559.y7gvoty7ksg4kw44@imap.linux.ibm.com>
References: <20070325164746.GI11794@in.ibm.com>
	<4606B6CF.6040306@in.ibm.com>
	<20070326115046.GK11794@in.ibm.com>
	<20070326105813.5678ea5d.pj@sgi.com>
	<20070327023559.y7gvoty7ksg4kw44@imap.linux.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, but the cpuset is not made invisible to userspace (in filesystem)  
> yet. So as cpuset_exit() discovers that cpuset B has zero refcount now  
> and blocks on mutex_lock(&manage_mutex) [ to do a check_for_release  
> later ], someone could have done a attach_task to that cpuset.

Agreed.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
