Return-Path: <linux-kernel-owner+w=401wt.eu-S1753055AbZJTUqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbZJTUqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753006AbZJTUqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:46:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbZJTUqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:46:49 -0400
Date: Tue, 20 Oct 2009 16:46:36 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: Darren Hart <dvhltc@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-rt-users@vger.kernel.org
Message-ID: <1953271756.544571256071596329.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4ADDD81B.3030208@us.ibm.com>
Subject: Re: [PATCH] futex: Detect mismatched requeue targets
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Darren Hart" <dvhltc@us.ibm.com> wrote:

> John Kacur wrote:
> > Hello Darren
> > 
> > I took your patch from commit
> 84bc4af59081ee974dd80210e694ab59ebe51ce8
> > and I tried to git-cherry-pick it for v2.6.31.4-rt14
> > 
> > I had a little merge-commit to resolve. That wasn't too hard, but as
> the 
> > code is a bit different between the two versions, I would appreciate
> it if 
> > you could review the patch, and make sure that it still makes sense
> for 
> > v2.6.31.r-rt14
> 
> Hi John,
> 
> It looks good to me.  Where did you have the conflicts?
> 
> --

The conflict was in the futex_wait_requeue_pi function.
That's where you really need to double check that the logic still makes sense.

Thanks.
