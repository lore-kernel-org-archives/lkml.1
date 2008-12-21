Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbYLUVTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbYLUVTt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 16:19:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbYLUVTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 16:19:41 -0500
Received: from www.tglx.de ([62.245.132.106]:60975 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbYLUVTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 16:19:41 -0500
Date: Sun, 21 Dec 2008 22:19:12 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: dsaxena@plexity.net
cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <srostedt@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: TSC not updating after resume: Bug or Feature?
In-Reply-To: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
Message-ID: <alpine.LFD.2.00.0812212217220.3739@localhost.localdomain>
References: <20081217172758.GA6010@trantor.hsd1.or.comcast.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deepak,

On Wed, 17 Dec 2008, Deepak Saxena wrote:
> 
> Hi,
> 
> I am using ftrace to get a detailed timing analysis of the resume process 
> on the OLPC XO laptop and am seeing that when we start running again, the
> system timestamep is not being updated for several (hundreds of) thousands 
> of cycles (~2000 ftrace entries). From following the ftrace, what is 
> happening is that the clocksource is not updated until we run the cpu_idle() 
> thread due to an explicit scheduling operation in the resume path that occurs 
> via call to msleep from pci_set_power_state().  As I'm still fully groking the 
> timekeeping code, the question(s) I have is whether this is expected behaviour 
> and I should not assume valid timestamp data in the initial bits of the suspend path, 
> whether this is an OLPC-specific bug, or whether I've uncovered a generic bug in 
> the timekeeping implementation.  This is on 2.6.27.7 as I've not gotten 28-rc 
> up and running on the XO but can move that up in priority if this behaviour
> is different in newer kernels.

Can you please upload the full trace somewhere ? 

Thanks,

	tglx
