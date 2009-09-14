Return-Path: <linux-kernel-owner+w=401wt.eu-S1750905AbZINEVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750905AbZINEVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 00:21:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750748AbZINEVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 00:21:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47227 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750739AbZINEVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 00:21:49 -0400
Date: Mon, 14 Sep 2009 06:20:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       Stephen Smalley <sds@tycho.nsa.gov>,
       David Howells <dhowells@redhat.com>
Subject: Re: [GIT] fix creds / SELinux regressions
Message-ID: <20090914042051.GA12296@elte.hu>
References: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com> <alpine.LRH.2.00.0909141256530.29020@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.0909141256530.29020@tundra.namei.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Morris <jmorris@namei.org> wrote:

> Hi Linus, please pull.
> 
> 
> The following changes since commit 86d710146fb9975f04c505ec78caa43d227c1018:
>   Linus Torvalds (1):
>         Merge git://git.linux-nfs.org/projects/trondmy/nfs-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6 for-linus
> 
> Eric Paris (3):
>       Creds: creds->security can be NULL is selinux is disabled
>       SELinux: seperate avc_cache flushing
>       SELinux: flush the avc before disabling SELinux
> 
>  include/linux/cred.h       |   13 ++++++++-----
>  include/linux/selinux.h    |    9 +++++++++
>  security/selinux/avc.c     |   26 +++++++++++++++++++-------
>  security/selinux/exports.c |    6 ++++++
>  4 files changed, 42 insertions(+), 12 deletions(-)

Guys, _please_ do better changelogs and describe how bugs were 
found. It doesnt matter for me personally but these commit logs 
utterly lack any description about how the bugs were 
found/triggered, how relevant they are in practice, there's no 
crashlog signatures in them for people to check, no Reported-by 
lines, etc.

	Ingo

