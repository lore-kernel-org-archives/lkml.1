Return-Path: <linux-kernel-owner+w=401wt.eu-S1753896AbXDSXVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbXDSXVD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 19:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbXDSXVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 19:21:01 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:38465 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753896AbXDSXVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 19:21:00 -0400
Date: Thu, 19 Apr 2007 16:20:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: <containers@lists.osdl.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Christoph Hellwig <hch@infradead.org>, <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH] bluetooth hidp: Convert to kthread API.
Message-Id: <20070419162037.ed6d3f93.akpm@linux-foundation.org>
In-Reply-To: <1176969605114-git-send-email-ebiederm@xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<1176969605114-git-send-email-ebiederm@xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 01:58:53 -0600
"Eric W. Biederman" <ebiederm@xmission.com> wrote:

> This patch starts up khidp using kthread_run instead
> of kernel_thread and daemonize, resulting is slightly
> simpler and more maintainable code.

argh, they're all like this :(

It's a shame your changelogs didn't fully spell out the reasons for
this conversion.  Right now, the maintainers probably think that these
are nice-to-have cleanups, not must-have-to-make-virtualisation-work-right
fixes.
