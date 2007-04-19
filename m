Return-Path: <linux-kernel-owner+w=401wt.eu-S1766630AbXDSNHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766630AbXDSNHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 09:07:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766669AbXDSNHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 09:07:33 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:45667 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766630AbXDSNHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 09:07:32 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: David Howells <dhowells@redhat.com>
Cc: "<Andrew Morton" <akpm@osdl.org>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/rxrpc: Convert to kthread API.
References: <11769696211263-git-send-email-ebiederm@xmission.com>
	<m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<29341.1176975158@redhat.com>
Date: Thu, 19 Apr 2007 07:05:32 -0600
In-Reply-To: <29341.1176975158@redhat.com> (David Howells's message of "Thu,
	19 Apr 2007 10:32:38 +0100")
Message-ID: <m1lkgoms4j.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> writes:

> Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> This patch modifies the startup of krxtimod, krxiod, and krxsecd
>> to use kthread_run instead of a combination of kernel_thread
>> and daemonize making the code slightly simpler and more maintainable.
>
> Again, please drop in favour of my RxRPC patches.

What is the ETA on your patches?

Eric
