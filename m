Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbXD0BMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbXD0BMy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 21:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbXD0BMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 21:12:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:43798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbXD0BMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 21:12:53 -0400
Message-ID: <46314E0B.1020800@zytor.com>
Date: Thu, 26 Apr 2007 18:12:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Michael McConnell <soruk@eridani.co.uk>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk> <463131FD.8020301@zytor.com> <20070427010914.GA2570@localhost.localdomain>
In-Reply-To: <20070427010914.GA2570@localhost.localdomain>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WANG Cong wrote:
>>
>> I have considered myself as a rather unofficial maintainer of this code,
>> and wouldn't mind make it official now when I actually have a job which
>> both cares about and actually can support my upstream Linux activities,
>> which was a major pain for a while.
>>
>> Overall, there is a lot of cleanup which really is needed in the i386
>> boot process; I have done some work on it already, but more is needed.
> 
> Sounds interesting. Can you point me what needs to be done exactly? Maybe I can help you. ;)

There was a long thread on the linux-virtualization list
(@lists.linux-foundation.org) just a few days ago.  The biggest single
issue right now is probably how we transition from the bootup page
tables to the "real" init_mm page tables, but the real-mode code also
needs a massive overhaul (especially so since this code can and should
be shared with x86-64); in particular I really want to get rid of the
insane segment handling, where segments are constantly recalculated for
no good reason.

For the real-mode stuff, I have some patches already in the works for
this.  Eric W. Biederman has also done a lot of work in this area.

	-hpa
