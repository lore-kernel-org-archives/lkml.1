Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbZHFAV0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbZHFAV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:21:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752410AbZHFAVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:21:25 -0400
Received: from tundra.namei.org ([65.99.196.166]:54488 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751806AbZHFAVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:21:25 -0400
Date: Thu, 6 Aug 2009 10:19:19 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, jwcart2@tycho.nsa.gov, sds@tycho.nsa.gov,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kees@outflux.net,
       csellers@tresys.com, penguin-kernel@i-love.sakura.ne.jp,
       serue@us.ibm.com
Subject: Re: [PATCH -v4 1/3] Capabilities: move cap_file_mmap to
 commoncap.c
In-Reply-To: <20090731165358.20992.14757.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0908061018530.7389@tundra.namei.org>
References: <20090731165358.20992.14757.stgit@paris.rdu.redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009, Eric Paris wrote:

> Currently we duplicate the mmap_min_addr test in cap_file_mmap and in
> security_file_mmap if !CONFIG_SECURITY.  This patch moves cap_file_mmap
> into commoncap.c and then calls that function directly from
> security_file_mmap ifndef CONFIG_SECURITY like all of the other capability
> checks are done.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: Serge Hallyn <serue@us.ibm.com>


All applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

Please test!

-- 
James Morris
<jmorris@namei.org>
