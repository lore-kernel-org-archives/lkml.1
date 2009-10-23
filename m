Return-Path: <linux-kernel-owner+w=401wt.eu-S1752280AbZJWPEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280AbZJWPEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 11:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZJWPEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 11:04:04 -0400
Received: from host-181-75-169-83.static.internet-fr.net ([83.169.75.181]:35604
	"EHLO seanodes.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752245AbZJWPED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 11:04:03 -0400
Message-ID: <4AE1C5C6.7000103@gmail.com>
Date: Fri, 23 Oct 2009 17:03:34 +0200
From: Erwan Velu <erwanaliasr1@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090822)
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] dmi_check_system can generate Warnings when no DMI table
 is present
References: <4AE178AF.3010804@gmail.com> <20091023110323.GC10071@elte.hu>	 <4AE19867.5070705@gmail.com> <1256302066.10493.74.camel@desktop>
In-Reply-To: <1256302066.10493.74.camel@desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker a écrit :
> [...]
> It's your defect, so you can still try to fix it (unless the "xen
> people" or someone else beats you to it.) 
>
> It looks like on a normal system dmi_scan_machine() gets called very
> early in setup_arch() arch/x86/kernel/setup.c . A possible good fix
> might be to add a dmi_disable() into the dmi driver that just shuts off
> dmi, and run that in xen_arch_setup() in arch/x86/xen/setup.c 
Could it make sense having this patch (I can work on it) while keeping 
my previous patch ?
Does it make sense keeping the default return value I've been adding 
when no dmi table is found ?
