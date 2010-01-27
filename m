Return-Path: <linux-kernel-owner+w=401wt.eu-S1754546Ab0A0CIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab0A0CIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 21:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753774Ab0A0CIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 21:08:17 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39140 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752064Ab0A0CIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 21:08:16 -0500
Date: Tue, 26 Jan 2010 18:07:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
       Roland McGrath <roland@redhat.com>, WANG Cong <amwang@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/binfmt_elf.c: fix a do-while statement.
Message-Id: <20100126180752.951509b5.akpm@linux-foundation.org>
In-Reply-To: <a4c8a6d01001261744n37e3472em8e772d9ecf368adf@mail.gmail.com>
References: <c370b092a68e66a2ac6c9d852967d843a1b574c0.1264046338.git.tfransosi@gmail.com>
	<20100126160632.3bdbe172.akpm@linux-foundation.org>
	<a4c8a6d01001261744n37e3472em8e772d9ecf368adf@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jan 2010 23:44:29 -0200 Thiago Farina <tfransosi@gmail.com> wrote:

> > It is somewhat unconventional coding style and it'd be good if
> > checkpatch were to warn so that we don't _add_ such things to the tree.
> >
> > But IMO it's such a minor thing that once it _is_ in the tree, it's not
> > really worth the patch noise to go and fix it up.
> 
> Yeah, much noise for a small thing. I will not fix more warnings like
> this in future.

I'd be OK with fixing things like this as part of a larger
"fs/binfmt_elf.c: coding-style fixes" or "fs/*elf.c: ...", etc.  One
big hit.  It's the little dribble of one-line fixes which I'd prefer to
avoid.

