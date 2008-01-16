Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYAPAWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYAPAWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 19:22:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbYAPAWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 19:22:22 -0500
Received: from ms0.nttdata.co.jp ([163.135.193.231]:44945 "EHLO
	ms0.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYAPAWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 19:22:21 -0500
Message-ID: <478D4E35.8000208@nttdata.co.jp>
Date: Wed, 16 Jan 2008 09:22:13 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #6 retry 02/21] Add struct vfsmount to struct task_struct.
References: <20080109005320.323184643@nttdata.co.jp> <20080109005418.469053691@nttdata.co.jp> <20080115211656.GA10644@sergelap.austin.ibm.com>
In-Reply-To: <20080115211656.GA10644@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2008 00:22:17.0827 (UTC) FILETIME=[DA113330:01C857D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> I must say I personally prefer the apparmor approach.
No problem.

> But I'd recommend
> you get together and get this piece pushed on its own, whichever version
> you can agree on.
TOMOYO can use AppArmor's patch.

> Yes it needs a user, but at this point I would think
> both tomoyo and apparmor have had enough visibility that everyone knows
> the intended users.
Not only AppArmor and TOMOYO but also SELinux want to use "vfsmount".
(http://marc.info/?l=selinux&m=120005904211942&w=2)

> It seems to me you're both being held up by this piece, and getting
> another full posting of either tomoyo or apparmor isn't going to help,
> so hopefully you can combine your efforts to get this solved.
We welcome AppArmor's vfsmount patches, but I wonder why AppArmor's
vfsmount patches are not merged yet.

What prevents AppArmor's vfsmount patches from merging into -mm tree?

Regards.
Kentaro Takeda

