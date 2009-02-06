Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbZBFXYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbZBFXYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZBFXYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:24:35 -0500
Received: from styx.suse.cz ([82.119.242.94]:41619 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751780AbZBFXYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:24:35 -0500
Date: Sat, 7 Feb 2009 00:24:33 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ben Greear <greearb@candelatech.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>, rusty@rustcorp.com.au
Subject: Re: PATCH:  Allow user to force 'tsc' to be treated as stable.
In-Reply-To: <498C78C9.5090405@candelatech.com>
Message-ID: <alpine.LNX.1.10.0902070022190.11630@jikos.suse.cz>
References: <498B42C5.7010905@candelatech.com> <alpine.LRH.1.10.0902061531560.22097@twin.jikos.cz> <498C78C9.5090405@candelatech.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Feb 2009, Ben Greear wrote:

> > How do you know that the TSC is stable on such system? What was the 
> > reason for kernel marking it unstable?
> I've used it for a timing source in my own modules and it has worked 
> well.  It could still be broken in some way, but if so, I'm not sure how 
> to detect it.  Ingo sent me a program to test the tsc, and at least for 
> short runs, it showed no problem.
> Another person suggested the system might think it is unstable because I 
> have ACPI disabled in my BIOS and that might cause the kernel not to 
> have a 'PM timer' that it uses to check the tsc?
> Other than that, I have no idea why the kernel thinks the tsc is 
> unstable.

Normally the reason should be indicated by kernel in dmesg output, could 
you please provide that?

Thanks,

-- 
Jiri Kosina
SUSE Labs
