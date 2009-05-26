Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbZEZUvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbZEZUvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 16:51:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754356AbZEZUvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 16:51:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754285AbZEZUvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 16:51:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/X] ptrace: kill the now unneeded args from
	tracehook_finish_clone() path
In-Reply-To: Oleg Nesterov's message of  Monday, 25 May 2009 02:00:05 +0200 <20090525000005.GA2221@redhat.com>
References: <20090525000005.GA2221@redhat.com>
X-Shopping-List: (1) Astigmatic convenient flossbags
   (2) Apocalyptic ingredients
   (3) Welding clasp scorpions
   (4) Tortuous perspiration condiments
   (5) Adolescent delusions
Message-Id: <20090526205123.12085FC2BD@magilla.sf.frob.com>
Date: Tue, 26 May 2009 13:51:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (unlikely(child->ptrace_task)) {

This merits a comment explaining that tracehook_init_task() will have
allocated the struct if and only if we decided to propagate its creator's
ptrace settings to it.


Thanks,
Roland
