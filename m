Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbYAQEzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbYAQEzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 23:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbYAQEzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 23:55:45 -0500
Received: from ms1.nttdata.co.jp ([163.135.193.232]:57151 "EHLO
	ms1.nttdata.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbYAQEzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 23:55:44 -0500
Message-ID: <478EDFC9.6050808@nttdata.co.jp>
Date: Thu, 17 Jan 2008 13:55:37 +0900
From: Kentaro Takeda <takedakn@nttdata.co.jp>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.8.1.9) Gecko/20071031 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>, Johansen@suse.de
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [TOMOYO #6 retry 02/21] Add struct vfsmount to struct task_struct.
References: <20080109005320.323184643@nttdata.co.jp> <20080109005418.469053691@nttdata.co.jp> <20080115211656.GA10644@sergelap.austin.ibm.com> <478D4E35.8000208@nttdata.co.jp> <20080116143943.GB19305@sergelap.austin.ibm.com>
In-Reply-To: <20080116143943.GB19305@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jan 2008 04:55:41.0138 (UTC) FILETIME=[359D9320:01C858C5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge:
> Right, but one will be preferred by the community - and while I have my
> own preference, I wouldn't put too much faith on that, rather talk with
> the apparmor folks, look over the lkml logs for previous submissions,
> and then decide.
Thanks for your advice.
We got the same advice from Jonathan@LWN in Embedded Linux Conference 2007,
and contacted AppArmor folks but no action occurred. We'll try to contact again.

John Johansen:
Both AppArmor and TOMOYO need vfsmount in LSM hooks. Although we suggested
another solution in [TOMOYO #6], we can use AppArmor's approach.
How about submitting only vfsmount patches before submitting AppArmor/TOMOYO
main module?

We think the patches relate to not only LSM folks but also fsdevel folks.
So we are going to post the brief description of the patches to fsdevel.

Regards,
Kentaro Takeda

