Return-Path: <linux-kernel-owner+w=401wt.eu-S1755458AbYAPOj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbYAPOj5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:39:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753918AbYAPOjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:39:46 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50257 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624AbYAPOjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:39:44 -0500
Date: Wed, 16 Jan 2008 08:39:43 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #6 retry 02/21] Add struct vfsmount to struct
	task_struct.
Message-ID: <20080116143943.GB19305@sergelap.austin.ibm.com>
References: <20080109005320.323184643@nttdata.co.jp> <20080109005418.469053691@nttdata.co.jp> <20080115211656.GA10644@sergelap.austin.ibm.com> <478D4E35.8000208@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <478D4E35.8000208@nttdata.co.jp>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kentaro Takeda (takedakn@nttdata.co.jp):
> Hello.
> 
> Serge E. Hallyn wrote:
> > I must say I personally prefer the apparmor approach.
> No problem.
> 
> > But I'd recommend
> > you get together and get this piece pushed on its own, whichever version
> > you can agree on.
> TOMOYO can use AppArmor's patch.

Right, but one will be preferred by the community - and while I have my
own preference, I wouldn't put too much faith on that, rather talk with
the apparmor folks, look over the lkml logs for previous submissions,
and then decide.

> > Yes it needs a user, but at this point I would think
> > both tomoyo and apparmor have had enough visibility that everyone knows
> > the intended users.
> Not only AppArmor and TOMOYO but also SELinux want to use "vfsmount".
> (http://marc.info/?l=selinux&m=120005904211942&w=2)
> 
> > It seems to me you're both being held up by this piece, and getting
> > another full posting of either tomoyo or apparmor isn't going to help,
> > so hopefully you can combine your efforts to get this solved.
> We welcome AppArmor's vfsmount patches, but I wonder why AppArmor's
> vfsmount patches are not merged yet.
> 
> What prevents AppArmor's vfsmount patches from merging into -mm tree?

I don't recall what objections remained at the last posting.  Far as I
know there may have simply been no responses due to patch fatigue.  (it
happens)

-serge
