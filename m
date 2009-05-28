Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbZE1VfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbZE1VfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 17:35:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751153AbZE1VfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 17:35:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZE1Ve7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 17:34:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/12 v2] ptrace: introduce task_struct->ptrace_cxt
In-Reply-To: Oleg Nesterov's message of  Thursday, 28 May 2009 13:35:33 +0200 <20090528113533.GA18670@redhat.com>
References: <20090528113533.GA18670@redhat.com>
X-Zippy-Says: Are we on STRIKE yet?
Message-Id: <20090528213439.C3587FC2BD@magilla.sf.frob.com>
Date: Thu, 28 May 2009 14:34:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

5/12 still needs a comment about its assumption that tracehook_init_task()
allocated the struct iff appropriate.  Some log entries (or maybe comments)
I saw said "->pt_*" though that is not the name of the field in the patch.
Other than the task_lock/kfree nit in 4/12 it all looks good to me so far.


Thanks,
Roland
