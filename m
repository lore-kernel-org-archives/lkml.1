Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbXD0FQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbXD0FQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbXD0FQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:16:56 -0400
Received: from terminus.zytor.com ([192.83.249.54]:42038 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355AbXD0FQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:16:55 -0400
Message-ID: <4631873B.1000107@zytor.com>
Date: Thu, 26 Apr 2007 22:16:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Michael McConnell <soruk@eridani.co.uk>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk> <463131FD.8020301@zytor.com>	<20070427010914.GA2570@localhost.localdomain>	<46314E0B.1020800@zytor.com>	<20070427023252.GA3797@localhost.localdomain> <m1647ijvk1.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1647ijvk1.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> WANG Cong <xiyou.wangcong@gmail.com> writes:
> 
>> Thanks for your point. 
>> I know little about virtualization, maybe can't help much. But I am interested
>> in other things you mentioned. AFAIK, segments can't be avoided on i386, and
>> Linux uses them very little, how are they recalculated constantly?
> 
> Look in arch/i386/boot/setup.S it runs in 16bit mode.  We are talking about
> real mode segments not 16bit segments.
> 
> 16bit real mode is a completely different ball game, and why we keep BIOS
> calls isolated to that one dinky file.
> 

A lot of that code (although, of course, not all) could be written in C,
though.  I'm thinking of taking a stab at rewriting it that way.

	-hpa
