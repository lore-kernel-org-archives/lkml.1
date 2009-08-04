Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbZHDXq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbZHDXq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 19:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbZHDXq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 19:46:29 -0400
Received: from tundra.namei.org ([65.99.196.166]:36810 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152AbZHDXq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 19:46:28 -0400
Date: Wed, 5 Aug 2009 09:42:06 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov, James Carter <jwcart2@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, spender@grsecurity.net,
       Daniel J Walsh <dwalsh@redhat.com>, cl@linux-foundation.org,
       Arjan van de Ven <arjan@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, kees@outflux.net,
       Chad Sellers <csellers@tresys.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -v4 1/3] Capabilities: move cap_file_mmap to
 commoncap.c
In-Reply-To: <20090731165358.20992.14757.stgit@paris.rdu.redhat.com>
Message-ID: <alpine.LRH.2.00.0908050938320.28805@tundra.namei.org>
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

These patches could do with more review / ack / signoff.  Anyone?  Bueller?

However, if there are no further comments, I'll likely apply these to 
security-testing#next.


- James
-- 
James Morris
<jmorris@namei.org>
