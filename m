Return-Path: <linux-kernel-owner+w=401wt.eu-S1752554AbZDUGa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554AbZDUGa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 02:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZDUGas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 02:30:48 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:38610 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbZDUGas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 02:30:48 -0400
Message-ID: <49ED6812.8020904@petalogix.com>
Date: Tue, 21 Apr 2009 08:30:42 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: monstr@monstr.eu, linux-kernel@vger.kernel.org,
       microblaze-uclinux@itee.uq.edu.au, Ingo Molnar <mingo@elte.hu>,
       David Howells <dhowells@redhat.com>
Subject: Re: Microblaze fixes for revision
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu> <20090420133125.3615a80d.akpm@linux-foundation.org>
In-Reply-To: <20090420133125.3615a80d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 16 Apr 2009 11:56:27 +0200
> monstr@monstr.eu wrote:
>
>   
>> here are some patches which fixed some minor things.
>>     
>
> How are microblaze patches getting into Linus's tree?
>   
I created two branches in git as Ingo suggested me.
1. for-linus -> this branch stores new features which comes to next
merge open window
2. fixes-for-linus -> this branch stores fixes which come to rc version

I asked Linus for pulling it to his tree. I think rc3 will be soon - the
changes which I sent for
reviewing to LKML are OK (except Kconfig patch 11/11 - which I removed
for now) - they are ready
in fixes-for-linus branch.
I'll write next pull request - some days after rc3.

> An appropriate route would be for you to ask him to pull the git tree. 
> I could send them (as I do with alpha, uml and maybe others), but
> that's more a last-resort way of maintaining an architecture.
>   
I think that my maintaining will be good for you and all.

> The microblaze git tree should be included in linux-next.  Please
> prepare a branch and send the info over to Stephen Rothwell
> <sfr@canb.auug.org.au> and linux-next@vger.kernel.org to get that all
> set up.
>   
OK. I will contact him to sort this things.

> For these particular patches: officially, 2.6.30-rcN is in bugfix-only
> mode.  But as microblaze is newly-added in 2.6.30 I think it's OK to
> put non-bugfixes into 2.6.30 as well - we might as well get the
> architecture as up-to-date as possible for the 2.6.30 release.
>   
Thanks but I don't need to add new feature now.
I am solving some problems with romfs which comes with David's romfs changes

And I am preparing MMU Microblaze patches which I want to send to review
to LKML soon. I have there only some things to solve (like add
__uClinux__ to headers). I tested it with LTP and the results are good.
I would like to have ACKs and add it in next merge open window.

Thanks,
Michal

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>   


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

