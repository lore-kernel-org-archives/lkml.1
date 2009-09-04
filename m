Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbZIDOBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbZIDOBU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 10:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756791AbZIDOBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 10:01:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbZIDOBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 10:01:19 -0400
Date: Fri, 4 Sep 2009 15:55:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       Tom Horsley <tom.horsley@att.net>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH 1/1] exec: do not sleep in TASK_TRACED under
	->cred_guard_mutex
Message-ID: <20090904135539.GA10400@redhat.com>
References: <20090904124604.GA6248@redhat.com> <20090903160514.GA23646@redhat.com> <29983.1252053547@redhat.com> <32320.1252071552@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32320.1252071552@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > (Argh. Sorry David, the changelog should have mentioned
> >  tracehook_report_exec() more explicitely).
> >
> > So, David, do you agree with this patch? Do you think it can go to 2.6.31 ?
>
> Okay, add my Acked-by.

Great.

> Can I recommend you mention tracehook_report_exec() in
> the changelog and then push it to Linus again?

OK, will do.

I just sent v2 (the same patch + a bit of comments). Please tell me
if you disagree with the comments.

Oleg.

