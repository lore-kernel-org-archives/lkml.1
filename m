Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbZBTDrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbZBTDrl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 22:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbZBTDrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 22:47:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50962 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbZBTDrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 22:47:32 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jerome Marchand <jmarchan@redhat.com>,
       Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/2] ptrace_detach: the wrong wakeup breaks the
	ERESTARTxxx logic
In-Reply-To: Oleg Nesterov's message of  Friday, 13 February 2009 11:54:37 +0100 <20090213105437.GA24320@redhat.com>
References: <20090213105437.GA24320@redhat.com>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090220034718.C5AAFFC2F7@magilla.sf.frob.com>
Date: Thu, 19 Feb 2009 19:47:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For TASK_TRACED, this wakeup is superfluous because of the one just done in
ptrace_untrace immediately prior.  For other cases it was always spurious
and the unconditional one looks quite wrong here.

Acked-By: Roland McGrath <roland@redhat.com>


Thanks,
Roland
