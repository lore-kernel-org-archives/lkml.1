Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbXDTBzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbXDTBzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 21:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXDTBzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 21:55:09 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894AbXDTBzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 21:55:05 -0400
Date: Thu, 19 Apr 2007 18:54:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] cpqphp: Convert to use the kthread API
Message-Id: <20070419185426.50de618f.akpm@linux-foundation.org>
In-Reply-To: <11769695592278-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769695592278-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:36 -0600 "Eric W. Biederman" <ebiederm@xmission.com> wrote:

> This patch changes cpqphp to use kthread_run and not
> kernel_thread and daemonize to startup and setup
> the cpqphp thread.

ok..  I'll rename this to "partially convert" and shall add a note
to the changelog,

This is another driver which will look a lot nicer when it has been
converted to kthread_should_stop() and kthread_stop()
