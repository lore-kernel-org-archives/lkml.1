Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYB0Tg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYB0Tg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 14:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbYB0Tgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 14:36:51 -0500
Received: from hpsmtp-eml20.KPNXCHANGE.COM ([213.75.38.85]:6283 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755434AbYB0Tgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 14:36:51 -0500
To: serge@hallyn.com
Subject: Re: at program breaks with kernel 2.6.24
Cc: buraphalinuxserver@gmail.com, linux-kernel@vger.kernel.org
In-reply-To: <20080227181740.GA14532@vino.hallyn.com>
References: <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com> <5d75f4610802270427y789ffae9ie2682059206eed51@mail.gmail.com> <20080227181740.GA14532@vino.hallyn.com>
Message-Id: <E1JUS56-0001ur-Tq@faramir.fjphome.nl>
From: Frans Pop <elendil@planet.nl>
Date: Wed, 27 Feb 2008 20:36:44 +0100
X-OriginalArrivalTime: 27 Feb 2008 19:36:47.0692 (UTC) FILETIME=[177948C0:01C87978]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serge@hallyn.com wrote:
> Quoting BuraphaLinux Server (buraphalinuxserver@gmail.com):
>> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=463669
>> 
>> I have the same problem - it is not debian specific.  Did the
>> semantics of kill() change with the new kernel?  I thought as long as
>> something is setuid, even with capability stuff around the setuid
>> programs just get _all_ capabilities and would keep working.
>> 
>> I did a good search and found many people with the problem, but no
>> solutions except going back to 2.6.23.x kernels.  I guess you'll flame
>> me, but at least include a link to the solution too.
> 
> Why would we flame you?  I'll just apologize as I think it's my fault,
> and ask you to please try the newest available kernel where I believe it
> should be fixed.

Would it be this commit that fixed this issue?
commit 094972840f2e7c1c6fc9e1a97d817cc17085378e
Author: Serge E. Hallyn <serue@us.ibm.com>
Date:   Sat Feb 23 15:23:33 2008 -0800
    file capabilities: simplify signal check

I see stable was CCed on it, so I guess it will be included in the next
point release, but distributions may want to apply it earlier.
