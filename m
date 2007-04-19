Return-Path: <linux-kernel-owner+w=401wt.eu-S1161485AbXDSJdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161485AbXDSJdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 05:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161484AbXDSJdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 05:33:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161485AbXDSJcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 05:32:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <11769696123525-git-send-email-ebiederm@xmission.com> 
References: <11769696123525-git-send-email-ebiederm@xmission.com>  <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> 
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/afs: Convert to kthread API. 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Thu, 19 Apr 2007 10:32:07 +0100
Message-ID: <29317.1176975127@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> This patch modifies the startup of kafscmd, kafsasyncd, and kafstimod
> to use kthread_run instead of a combination of kernel_thread and
> daemonize making the code slightly simpler and more maintainable.

Please drop this patch for the moment as I have my own patches to convert them
to keventd-type threads, in addition to implementing a host of other changes.

David
