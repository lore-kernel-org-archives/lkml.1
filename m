Return-Path: <linux-kernel-owner+w=401wt.eu-S1756657AbXJBMso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657AbXJBMso (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 08:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbXJBMsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 08:48:36 -0400
Received: from namei.org ([69.55.235.186]:50740 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753028AbXJBMsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 08:48:35 -0400
Date: Tue, 2 Oct 2007 05:48:17 -0700 (PDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Kentaro Takeda <takedakn@nttdata.co.jp>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       chrisw@sous-sol.org
Subject: Re: [TOMOYO 14/15](repost) LSM expansion for TOMOYO Linux.
In-Reply-To: <4701F5CC.7040209@nttdata.co.jp>
Message-ID: <Xine.LNX.4.64.0710020546260.21841@us.intercode.com.au>
References: <4701F285.5000206@nttdata.co.jp> <4701F5CC.7040209@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Oct 2007, Kentaro Takeda wrote:

> LSM expansion for TOMOYO Linux.
> 
> LSM hooks for sending signal:
>    * task_kill_unlocked is added in sys_kill
>    * task_tkill_unlocked is added in sys_tkill
>    * task_tgkill_unlocked is added in sys_tgkill

Why do you need racy unlocked versions, in addition to the existing 
security_task_kill() hook which is called safely via 
check_kill_permission() ?


- James
-- 
James Morris
<jmorris@namei.org>
