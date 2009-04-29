Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZD2ONm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZD2ONm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 10:13:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbZD2ONc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 10:13:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57187 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbZD2ONc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 10:13:32 -0400
Date: Wed, 29 Apr 2009 16:08:36 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: ptrace: selinux_bprm_committed_creds: simplify
	__wake_up_parent() code and s/parent/real_parent/
Message-ID: <20090429140836.GB31948@redhat.com>
References: <20090428223025.GA11997@redhat.com> <1241011116.18249.193.camel@localhost.localdomain> <20090429140224.GA31948@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429140224.GA31948@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn. Forgot to add "[PATCH]" to the subject, hopefully not a problem.

On 04/29, Oleg Nesterov wrote:
>
> selinux_bprm_committed_creds() should wake up ->real_parent, not ->parent.

Afaics, with this patch the only user of ->parent outside of ptrace.c & co
is arch/ia64/kernel/mca.c:format_mca_init_stack(). Hopefully ->parent will
die soon.

Oleg.

