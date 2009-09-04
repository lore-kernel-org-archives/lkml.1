Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbZIDJ0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbZIDJ0c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933298AbZIDJ0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:26:31 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:41209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933280AbZIDJ0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:26:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Tom Horsley <tom.horsley@att.net>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under ->cred_guard_mutex
In-Reply-To: David Howells's message of  Friday, 4 September 2009 09:39:07 +0100 <29983.1252053547@redhat.com>
References: <20090903160514.GA23646@redhat.com>
	<29983.1252053547@redhat.com>
X-Zippy-Says: Everywhere I look I see NEGATIVITY and ASPHALT...
Message-Id: <20090904092402.A18EB8B12A@magilla.sf.frob.com>
Date: Fri,  4 Sep 2009 02:24:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +int prepare_bprm_creds(struct linux_binprm *bprm)
> > +{
> 
> __acquires()
> 
> > +void free_bprm(struct linux_binprm *bprm)
> > +{
> 
> __releases()

No, they're conditional.


Thanks,
Roland
