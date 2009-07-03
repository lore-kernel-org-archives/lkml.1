Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbZGCKQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbZGCKQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbZGCKQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:16:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52765 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317AbZGCKQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:16:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090703092311.GA3712@redhat.com>
References: <20090703092311.GA3712@redhat.com> <200906301951.n5UJpUSY013305@imap1.linux-foundation.org> <11314.1246585948@turing-police.cc.vt.edu> <20090702192047.10b81ada.akpm@linux-foundation.org> <20090703081821.GA4051@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>
Subject: Re: [PATCH] selinux_bprm_committed_creds: use __wake_up_parent()
Date: Fri, 03 Jul 2009 11:16:32 +0100
Message-ID: <3545.1246616192@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> (depends on ptrace-__ptrace_detach-do-__wake_up_parent-if-we-reap-the-tracee.patch
>  which exports __wake_up_parent)
> 
> Spotted by Valdis.Kletnieks@vt.edu.

You probably want to add this as a 'Reported-by' tag.

> selinux_bprm_committed_creds() should not play with ->wait_chldexit, now
> that __wake_up_parent() is exported change the code to use this helper.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: David Howells <dhowells@redhat.com>
