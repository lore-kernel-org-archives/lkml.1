Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095AbZD2Ncs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095AbZD2Ncs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751843AbZD2Nci
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:32:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40049 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbZD2Nci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:32:38 -0400
Date: Wed, 29 Apr 2009 15:28:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
Message-ID: <20090429132844.GB29151@redhat.com>
References: <19024.1241008933@redhat.com> <20090429115550.GA25368@redhat.com> <20090429102511.GA10767@redhat.com> <20090429065809.GA477@redhat.com> <20090428223025.GA11997@redhat.com> <alpine.LRH.2.00.0904291024001.5246@tundra.namei.org> <7242.1240999370@redhat.com> <7150.1241003840@redhat.com> <19233.1241009105@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19233.1241009105@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29, David Howells wrote:
>
> From: David Howells <dhowells@redhat.com>
> Subject: [PATCH] SELinux: Don't flush inherited SIGKILL during execve()
>
> Don't flush inherited SIGKILL during execve() in SELinux's post cred commit
> hook.  This isn't really a security problem: if the SIGKILL came before the
> credentials were changed, then we were right to receive it at the time, and
> should honour it; if it came after the creds were changed, then we definitely
> should honour it; and in any case, all that will happen is that the process
> will be scrapped before it ever returns to userspace.
>
> Signed-off-by: David Howells <dhowells@redhat.com>

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

