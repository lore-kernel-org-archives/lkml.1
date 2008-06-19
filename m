Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbYFSFXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbYFSFXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:23:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751462AbYFSFXA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:23:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47024 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbYFSFW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:22:59 -0400
Message-ID: <4859E9F0.6010001@zytor.com>
Date: Wed, 18 Jun 2008 22:09:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: update mptable v7
References: <200805041823.57198.yhlu.kernel@gmail.com>	<200805191252.36814.yhlu.kernel@gmail.com>	<200805251600.26325.yhlu.kernel@gmail.com>	<200806011317.38622.yhlu.kernel@gmail.com>	<alpine.LFD.1.10.0806181812580.3074@localhost.localdomain>	<86802c440806181532g348864e1u3d067f8366046a7f@mail.gmail.com>	<alpine.LFD.1.10.0806182031060.3074@localhost.localdomain>	<86802c440806181749g2faf1892iea693717ea919631@mail.gmail.com> <m1mylim4e6.fsf@frodo.ebiederm.org>
In-Reply-To: <m1mylim4e6.fsf@frodo.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> Silly question.  Given that even writing to this table is platform specific.
> Any chance we can do this any a userspace utility writing through /dev/mem
> for the systems that need it?   We can even bundle the utility in the kexec-tools
> package to make it easier to distribute.
> 

I would prefer this to an in-kernel solution.  I really feel this is too 
ugly to live.

	-hpa
