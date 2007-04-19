Return-Path: <linux-kernel-owner+w=401wt.eu-S1766995AbXDSVZK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766995AbXDSVZK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:25:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767000AbXDSVZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:25:10 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57411 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766995AbXDSVZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:25:09 -0400
Subject: Re: [PATCH] nfs lockd reclaimer: Convert to kthread API
From: Dave Hansen <hansendc@us.ibm.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Neil Brown <neilb@suse.de>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1177017564.6628.5.camel@heimdal.trondhjem.org>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	 <11769696321319-git-send-email-ebiederm@xmission.com>
	 <1176999710.6663.12.camel@heimdal.trondhjem.org>
	 <m1slawkw76.fsf@ebiederm.dsl.xmission.com>
	 <1177017564.6628.5.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 14:25:02 -0700
Message-Id: <1177017902.12599.173.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-19 at 17:19 -0400, Trond Myklebust wrote:
> > With pid namespaces all kernel threads will disappear so how do
> > we cope with the problem when the sysadmin can not see the kernel
> > threads?

Do they actually always disappear, or do we keep them in the
init_pid_namespace?

-- Dave

