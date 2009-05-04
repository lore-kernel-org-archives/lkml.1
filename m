Return-Path: <linux-kernel-owner+w=401wt.eu-S932296AbZEDRkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296AbZEDRkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 13:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758152AbZEDRkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 13:40:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758077AbZEDRj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 13:39:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: do not use task->ptrace directly in core kernel
In-Reply-To: Oleg Nesterov's message of  Sunday, 3 May 2009 21:54:04 +0200 <20090503195404.GA18889@redhat.com>
References: <20090429122827.GA27838@redhat.com>
	<20090430202828.8A763FC3BF@magilla.sf.frob.com>
	<20090503195404.GA18889@redhat.com>
X-Zippy-Says: Yow!  Are we in the perfect mood?
Message-Id: <20090504173916.42AC5FC32F@magilla.sf.frob.com>
Date: Mon,  4 May 2009 10:39:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes this patch is only cosmetic. But it allows us to change the internals
> in ptrace.c without thinking about other kernel/*.c. The only goal is to
> make the further changes smaller and more reviewable.
> 
> Honestly, I'd also like to temporary change ptrace.c too, see the patch
> below. But this is minor.

All fine by me.


Thanks,
Roland
