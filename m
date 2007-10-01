Return-Path: <linux-kernel-owner+w=401wt.eu-S1754242AbXJAXuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242AbXJAXuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 19:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752433AbXJAXt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 19:49:59 -0400
Received: from gw.goop.org ([64.81.55.164]:60254 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbXJAXt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 19:49:58 -0400
Message-ID: <470187A5.9060700@goop.org>
Date: Mon, 01 Oct 2007 16:49:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: William Cattey <wdc@MIT.EDU>
CC: Andi Kleen <andi@firstfloor.org>, Chuck Anderson <cra@WPI.EDU>,
       linux-kernel@vger.kernel.org
Subject: Re: vm86.c audit_syscall_exit() call trashes registers
References: <20070814183119.GC17694@angus.ind.WPI.EDU> <p73r6m5n90l.fsf@bingen.suse.de> <78642229-39DD-4956-9385-5A3F960BFEEF@mit.edu> <20070814212858.GB23308@one.firstfloor.org> <07759638-DE7C-4341-A642-D611A897614F@MIT.EDU> <20070814214622.GE23308@one.firstfloor.org> <6655DD8B-D9C6-495D-9E22-2FDF6B375C9D@MIT.EDU> <20070814221927.GH23308@one.firstfloor.org> <9D5ACA40-5F33-4F49-8255-D51F554889E7@MIT.EDU> <46FDA325.8000602@goop.org> <7CB783C7-8EC7-4AA3-B825-B23595373229@MIT.EDU> <46FDEB6D.6000403@goop.org> <46FDEC1F.7080809@goop.org> <7CF81651-4B94-42AA-9FEF-790F4D08EE4F@MIT.EDU>
In-Reply-To: <7CF81651-4B94-42AA-9FEF-790F4D08EE4F@MIT.EDU>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Cattey wrote:
> Thanks very much for responding.
>
> From your two replies, I crafted the attached patch.
> Alas, the EDID transfer comes up all zeros.
> I see two possible causes of this behavior:
>
> 1. I misunderstood how you intended the file to be modified.
> 2. The fix for my bug is NOT in correcting the audit call, but instead
> from some other fix, perhaps from the other aspect that you worked on.
>
> I know that when I surrounded the audit_syscall_exit with #if 0 I got
> correct EDID fetches, so the most likely cause is #1, that I didn't
> correctly incorporate your understanding of correct operation of the
> call to audit_syscall_exit.
>
> Here's my patch.  Where did I screw up?

Not sure, it looks OK to me. I guess it could be something else that got
fixed in that change; I'll have another look.

Can you explain again what works and what doesn't?  Do you have auditing
enabled, or does it break things anyway?

    J
