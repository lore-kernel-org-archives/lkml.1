Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab0CATrc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:47:32 -0500
Received: from smtp-out.google.com ([216.239.33.17]:12024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0CATr2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:47:28 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=F3WvHYduChmZUHOUJmLxn/fxQdkEuCyxLJxjKV8z2BFEDIlkzwqiAj33bMiWeqyAG
	QJgHi7eQn8Axf+Ge9Wv6Q==
MIME-Version: 1.0
In-Reply-To: <tip-1883c79a57a5fe25309007590cccb1b2782c41b2@git.kernel.org>
References: <1267311188-16603-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <tip-1883c79a57a5fe25309007590cccb1b2782c41b2@git.kernel.org>
Date: Mon, 1 Mar 2010 11:47:22 -0800
Message-ID: <6599ad831003011147y41a34db4o2a5e78961b0be87b@mail.gmail.com>
Subject: Re: [tip:core/rcu] rcu: Make task_subsys_state() RCU-lockdep checks 
	handle boot-time use
From: Paul Menage <menage@google.com>
To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 12:59 AM, tip-bot for Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> Commit-ID:  1883c79a57a5fe25309007590cccb1b2782c41b2
> Gitweb:     http://git.kernel.org/tip/1883c79a57a5fe25309007590cccb1b2782c41b2
> Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> AuthorDate: Sat, 27 Feb 2010 14:53:08 -0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Sun, 28 Feb 2010 09:17:42 +0100
>
> rcu: Make task_subsys_state() RCU-lockdep checks handle boot-time use
>
> It is apparently legal to invoke task_subsys_state() without RCU
> protection during early boot time.  After all, there are no
> concurrent tasks, so there can be no grace periods completing
> concurrently.
>
> But this does need an Acked-by from the cgroups folks.
>
> Located-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Paul Menage <menage@google.com>

Thanks.

Paul
