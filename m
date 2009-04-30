Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbZD3Udo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbZD3Udo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 16:33:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750797AbZD3Udg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 16:33:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbZD3Udf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 16:33:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Eric Paris <eparis@parisplace.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] do_wait: do take security_task_wait() into account
In-Reply-To: Oleg Nesterov's message of  Wednesday, 29 April 2009 18:01:23 +0200 <20090429160123.GA4591@redhat.com>
References: <20090428223025.GA11997@redhat.com>
	<20090428233305.GA14221@redhat.com>
	<20090429160123.GA4591@redhat.com>
Emacs: Our Lady of Perpetual Garbage Collection
Message-Id: <20090430203154.77621FC3BF@magilla.sf.frob.com>
Date: Thu, 30 Apr 2009 13:31:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pretty sure this was just an unintended change when we did the do_wait
reorganization in 2.6.27.  Nobody noticed since the SELinux policy bugs
that made that error diagnosis relevant were fixed a long time before.

Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
