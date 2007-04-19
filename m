Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbXDSXGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbXDSXGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXDSXGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:06:25 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753965AbXDSXGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:06:25 -0400
Date: Thu, 19 Apr 2007 16:05:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rxrpc: Convert to kthread API.
Message-Id: <20070419160530.1fed265f.akpm@linux-foundation.org>
In-Reply-To: <29341.1176975158@redhat.com>
References: <11769696211263-git-send-email-ebiederm@xmission.com>
	<m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<29341.1176975158@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 10:32:38 +0100
David Howells <dhowells@redhat.com> wrote:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > This patch modifies the startup of krxtimod, krxiod, and krxsecd
> > to use kthread_run instead of a combination of kernel_thread
> > and daemonize making the code slightly simpler and more maintainable.
> 
> Again, please drop in favour of my RxRPC patches.
> 

Do those patches convert all this code over to full use of the kthread
API?  Because it seems that a conversion would be straightforward, and
is needed.
