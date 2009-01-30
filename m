Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbZA3WLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbZA3WLn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 17:11:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZA3WLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 17:11:34 -0500
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:36419 "EHLO
	QMTA04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754213AbZA3WLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 17:11:34 -0500
Message-ID: <49837B32.3010206@xyzw.org>
Date: Fri, 30 Jan 2009 14:12:02 -0800
From: Brian Rogers <brian@xyzw.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: Nathanael Hoyle <nhoyle@hoyletech.com>,
       Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: scheduler nice 19 versus 'idle' behavior / static low-priority
 scheduling
References: <1233294584.28741.2.camel@localhost>	 <alpine.LSU.2.00.0901300710200.999@fbirervta.pbzchgretzou.qr>	 <1233297635.17301.11.camel@localhost>	 <alpine.LSU.2.00.0901300818580.28427@fbirervta.pbzchgretzou.qr>	 <1233302349.17301.27.camel@localhost> <1233302861.6061.14.camel@marge.simson.net>
In-Reply-To: <1233302861.6061.14.camel@marge.simson.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Fri, 2009-01-30 at 02:59 -0500, Nathanael Hoyle wrote:
>   
>> I am running foldingathome under it at the moment, and it seems to be
>> improving the situation somewhat, but I still need/want to test with
>> Mike's referenced patches.
>>     
> You will most definitely encounter evilness running SCHED_IDLE tasks in
> a kernel without the SCHED_IDLE fixes.
>   
Speaking of SCHED_IDLE fixes, is 
6bc912b71b6f33b041cfde93ca3f019cbaa852bc going to be put into the next 
stable 2.6.28 release? Without it on 2.6.28.2, I can still produce 
minutes-long freezes with BOINC or other idle processes.

With the above commit on top of 2.6.28.2 and also 
cce7ade803699463ecc62a065ca522004f7ccb3d, the problem is solved, though 
I assume cce7ad isn't actually required to fix that, and I can test that 
if desired.

