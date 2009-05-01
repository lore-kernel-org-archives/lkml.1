Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZEAAup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZEAAup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753306AbZEAAug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:50:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46734 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443AbZEAAuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:50:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Eric Paris <eparis@parisplace.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: Re: Q: selinux_bprm_committed_creds() && signals/do_wait
In-Reply-To: David Howells's message of  Friday, 1 May 2009 01:44:34 +0100 <18312.1241138674@redhat.com>
References: <20090501000222.8BACEFC3BF@magilla.sf.frob.com>
	<20090428223025.GA11997@redhat.com>
	<18312.1241138674@redhat.com>
X-Zippy-Says: Excuse me, but didn't I tell you there's NO HOPE for the survival
    of OFFSET PRINTING?
Message-Id: <20090501005018.63C12FC3BF@magilla.sf.frob.com>
Date: Thu, 30 Apr 2009 17:50:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I believe it's something to do with the binfmt driver needing to access files
> in the old security context between calling flush_old_exec() and calling
> install_exec_creds() [compute_creds() as was].  It can't do some of the
> accesses before calling flush_old_exec() because it has to do funky things
> with mmap().

This doesn't make too much sense to me off hand.  These accesses must
already be specially magical for unreadable setuid (--s) files to work.


Thanks,
Roland
