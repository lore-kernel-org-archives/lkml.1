Return-Path: <linux-kernel-owner+w=401wt.eu-S1752956AbYI2NdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956AbYI2NdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 09:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYI2NdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 09:33:08 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:52723 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbYI2NdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 09:33:06 -0400
Message-ID: <48E0D957.5080907@in.ibm.com>
Date: Mon, 29 Sep 2008 19:04:15 +0530
From: Srinivasa DS <srinivasa@in.ibm.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-parisc@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] Demultiplexing SIGTRAP signal -v2
References: <200809221602.32616.srinivasa@in.ibm.com> <20080923112812.GL29021@elte.hu> <20080923113001.GA12531@elte.hu> <200809231955.01564.srinivasa@in.ibm.com> <20080923143120.GD14041@elte.hu> <20080926090637.9C0851541FA@magilla.localdomain>
In-Reply-To: <20080926090637.9C0851541FA@magilla.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I certainly have no objection in principle.  I doubt that any x86 userland
> apps expect certain si_code values for SIGTRAP now, since the existing
> values are not of any real use.  (Signal handlers get the thread.trap_no and
> thread.error_code values from hardware to guess from, and debuggers via
> ptrace get the hardware %db6 value to guess from.)  I do have a few comments.
> 
> If you're doing it, I think you should do the do_int3 case too,
> so every machine-generated SIGTRAP has a meaningful si_code value.

Roland
    Thanks for your comments.

>   I'm inclined to consolidate the si_code logic there, and just
> pass it the hardware bits or let it get them from the thread_struct
> (trap_nr, error_code, debugreg6).

That sounds like a good idea. Let me go through code and get back to you.

Thanks
  Srinivasa DS

