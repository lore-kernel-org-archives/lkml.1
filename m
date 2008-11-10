Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYKJCZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYKJCZa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 21:25:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbYKJCZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 21:25:20 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62350 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYKJCZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 21:25:19 -0500
Message-Id: <200811100224.mAA2ORgv096549@www262.sakura.ne.jp>
Subject: Re: [TOMOYO #12 (2.6.28-rc2-mm1) 06/11] Common functions for TOMOYOLinux.
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: serue@us.ibm.com
Cc: akpm@linux-foundation.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, takedakn@nttdata.co.jp,
       haradats@nttdata.co.jp, penguin-kernel@i-love.sakura.ne.jp
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Nov 2008 11:24:27 +0900
References: <20081104060847.086543472@nttdata.co.jp> <20081104060951.618445959@nttdata.co.jp> <20081105151221.d605226f.akpm@linux-foundation.org> <200811090138.GBG65138.FVOHOJOtMLQFFS@I-love.SAKURA.ne.jp> <20081110004131.GA25021@us.ibm.com>
In-Reply-To: <20081110004131.GA25021@us.ibm.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Serge E. Hallyn wrote:
> > There are two PIDs, PID seen from inside virtualized environment and
> > PID seen from outside virtualized environment. To clarify, let me call
> > the former "PIDv" and the latter "PIDg".
> > 
> > PIDv is not system-wide unique. But PIDg is system-wide unique, aren't they?
> > The PID received from outside virtualized environment is PIDg and they are
> > system-wide unique, am I right?
> 
> You are doing find_task_by_vpid(), so you are not looking up a task by
> global pid.
> 
I need to clarify reachability of "struct task_struct".

A process inside a virtualized environment cannot reach "struct task_struct"
which belongs to outside the virtualized environment.

A process outside virtualized environments can reach "struct task_struct"
which belongs to inside virtualized environments, can't it?

Regards.
