Return-Path: <linux-kernel-owner+w=401wt.eu-S1762856AbXJPCdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762856AbXJPCdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 22:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757667AbXJPCdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 22:33:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:51426 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757555AbXJPCdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 22:33:08 -0400
Date: Mon, 15 Oct 2007 19:32:59 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: menage@google.com, nickpiggin@yahoo.com.au, a.p.zijlstra@chello.nl,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, clg@fr.ibm.com,
       ebiederm@xmission.com, containers@lists.osdl.org, serue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [RFC] cpuset update_cgroup_cpus_allowed
Message-Id: <20071015193259.f9eb51b2.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710151135150.24837@chino.kir.corp.google.com>
References: <20071015071115.16057.72116.sendpatchset@jackhammer.engr.sgi.com>
	<alpine.DEB.0.9999.0710151135150.24837@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yet by not doing any locking here to prevent a cpu from being 
> hot-unplugged, you can race and allow the hot-unplug event to happen 
> before calling set_cpus_allowed().  That makes this entire function a 
> no-op with set_cpus_allowed() returning -EINVAL for every call, which 
> isn't caught, and no error is reported to userspace.

Good point ... hmmm ...

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
