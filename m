Return-Path: <linux-kernel-owner+w=401wt.eu-S1762240AbZATQNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762240AbZATQNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 11:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756061AbZATQNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 11:13:32 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:49833 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZATQNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 11:13:32 -0500
Date: Tue, 20 Jan 2009 08:09:34 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: ebiederm@xmission.com, roland@redhat.com, bastian@waldi.eu.org,
       daniel@hozac.com, xemul@openvz.org, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7][v7] proc: Show SIG_DFL signals to init as
	"ignored" signals
Message-ID: <20090120160933.GA25630@us.ibm.com>
References: <20090117202638.GA11825@us.ibm.com> <20090117203753.GH11825@us.ibm.com> <20090117221909.GB3962@redhat.com> <20090120010453.GA14612@us.ibm.com> <20090120073305.GA29130@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120073305.GA29130@redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

| 
| > | Imho, this patch can confuse the user-space. Why should we report that,
| > | say, SIGCONT is ignored by the global init?
| >
| > But it is ignored right ?
| 
| Following this logic, we can report that, say, SIG_DFL'ed SIGWINCH is always
| ignored by any task, not only by init?

Small difference with SIGWINCH though. SIGWINCH default action applies
to all processes. But the special behavior for SIGKILL only applies to
init. But yes, its an old oddity.

| I guess you already see that personally I dislike this patch ;) At least
| I'd ask you to not mix it with this series.

Ok.

| 
| But perhaps I am wrong, I can't "prove" this change is not good, I'd be
| ready to agree with majority.

I can't prove the opposite either. Will go with the majority...

Roland, Eric, Bastian. Any comments ? Should I send patches 1-6 to akpm ?

Sukadev
