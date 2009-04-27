Return-Path: <linux-kernel-owner+w=401wt.eu-S1757755AbZD0Rog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755AbZD0Rog (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZD0Ro2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:44:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269AbZD0Ro1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:44:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Howells <dhowells@redhat.com>
X-Fcc: ~/Mail/linus
Cc: torvalds@osdl.org, akpm@linux-foundation.org, hch@lst.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] FRV: utrace: Implement TIF_NOTIFY_RESUME
In-Reply-To: David Howells's message of  Monday, 27 April 2009 17:15:46 +0100 <20090427161545.16200.54250.stgit@warthog.procyon.org.uk>
References: <20090427161540.16200.23710.stgit@warthog.procyon.org.uk>
	<20090427161545.16200.54250.stgit@warthog.procyon.org.uk>
Emacs: a learning curve that you can use as a plumb line.
Message-Id: <20090427174151.6A284FC3BF@magilla.sf.frob.com>
Date: Mon, 27 Apr 2009 10:41:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	/* deal with notification on about to resume userspace execution */
> +	if (thread_info_flags & _TIF_NOTIFY_RESUME) {
> +		clear_thread_flag(TIF_NOTIFY_RESUME);
This needs:
		tracehook_notify_resume(regs);
> +	}

Thanks,
Roland
