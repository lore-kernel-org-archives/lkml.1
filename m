Return-Path: <linux-kernel-owner+w=401wt.eu-S1753318AbZIAItM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318AbZIAItM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbZIAItL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:49:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:38382 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400AbZIAItK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:49:10 -0400
Date: Tue, 1 Sep 2009 18:48:25 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Jiri Slaby <jirislaby@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       oleg@redhat.com, linux-kernel@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       David Howells <dhowells@redhat.com>,
       linux-security-module@vger.kernel.org,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [PATCH 1/6] SECURITY: selinux, fix update_rlimit_cpu parameter
In-Reply-To: <4A9CBD22.1050401@gmail.com>
Message-ID: <alpine.LRH.2.00.0909011848030.28277@tundra.namei.org>
References: <1251744974-29398-1-git-send-email-jirislaby@gmail.com> <alpine.LRH.2.00.0909010811320.22374@tundra.namei.org> <4A9CBD22.1050401@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Sep 2009, Jiri Slaby wrote:

> > This doesn't look correct to me: the original code determines 
> > rlim->rlim_cur and then updates current to that.  With your change, this 
> > value is not used.
> 
> No, the for loop is to alter all limits according to the init limits.

Ahh, ok, I misread the code.

> 
> update_rlimit_cpu is called for RLIMIT_CPU to annotate scheduler about
> CPU time changes (if any).
> 
> BTW this was introduced by f06febc96ba8e0af80bcc3eaec0a109e88275fac
> (timers: fix itimer/many thread hang).
> 

-- 
James Morris
<jmorris@namei.org>
