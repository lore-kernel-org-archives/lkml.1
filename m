Return-Path: <linux-kernel-owner+w=401wt.eu-S1761435AbZD3AiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761435AbZD3AiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 20:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753595AbZD3AiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 20:38:12 -0400
Received: from tundra.namei.org ([65.99.196.166]:36436 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbZD3AiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 20:38:12 -0400
Date: Thu, 30 Apr 2009 10:37:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
In-Reply-To: <20090429132844.GB29151@redhat.com>
Message-ID: <alpine.LRH.2.00.0904301037160.17896@tundra.namei.org>
References: <19024.1241008933@redhat.com> <20090429115550.GA25368@redhat.com> <20090429102511.GA10767@redhat.com> <20090429065809.GA477@redhat.com> <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org> <7242.1240999370@redhat.com>
 <7150.1241003840@redhat.com> <19233.1241009105@redhat.com> <20090429132844.GB29151@redhat.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Apr 2009, Oleg Nesterov wrote:

> On 04/29, David Howells wrote:
> >
> > From: David Howells <dhowells@redhat.com>
> > Subject: [PATCH] SELinux: Don't flush inherited SIGKILL during execve()
> >
> > Don't flush inherited SIGKILL during execve() in SELinux's post cred commit
> > hook.  This isn't really a security problem: if the SIGKILL came before the
> > credentials were changed, then we were right to receive it at the time, and
> > should honour it; if it came after the creds were changed, then we definitely
> > should honour it; and in any case, all that will happen is that the process
> > will be scrapped before it ever returns to userspace.
> >
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Applied to 
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next


-- 
James Morris
<jmorris@namei.org>
