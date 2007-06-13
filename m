Return-Path: <linux-kernel-owner+w=401wt.eu-S1757471AbXFMXIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471AbXFMXIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 19:08:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755909AbXFMXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 19:08:43 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:54643 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753502AbXFMXIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 19:08:43 -0400
Date: Wed, 13 Jun 2007 16:08:40 -0700
From: Paul Jackson <pj@sgi.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com, balbir@in.ibm.com,
       cpw@sgi.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       mbligh@google.com, rohitseth@google.com, devel@openvz.org
Subject: Re: [PATCH 1/2] containers: implement subsys->post_clone()
Message-Id: <20070613160840.022bec6a.pj@sgi.com>
In-Reply-To: <20070613225656.GA989@sergelap.austin.ibm.com>
References: <20070613225656.GA989@sergelap.austin.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Only the cpuset_post_clone() is currently implemented.  If any
> sibling containers have exclusive cpus or mems, then the cpus
> and mems are not filled in for the new container, meaning that
> unshare/clone(CLONE_NEWNS) will be denied.  However so long as
> no siblings have exclusive cpus or mems, the new container's
> cpus and mems are inherited from the parent container.

I'm ok with this part.

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
