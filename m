Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZHNB6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZHNB6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 21:58:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753567AbZHNB63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 21:58:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:48157 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbZHNB62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 21:58:28 -0400
Date: Fri, 14 Aug 2009 11:56:23 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
       sds@tycho.nsa.gov, davem@davemloft.net, shemminger@linux-foundation.org,
       kees@ubuntu.com, morgan@kernel.org, casey@schaufler-ca.com,
       dwalsh@redhat.com
Subject: Re: [PATCH 1/3] Networking: use CAP_NET_ADMIN when deciding to call
 request_module
In-Reply-To: <20090813134451.29186.41664.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0908141155290.12192@tundra.namei.org>
References: <20090813134451.29186.41664.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Eric Paris wrote:

> The networking code checks CAP_SYS_MODULE before using request_module() to


I applied all three patches to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

and fixed up the documentation per Serge's suggestion.


-- 
James Morris
<jmorris@namei.org>
