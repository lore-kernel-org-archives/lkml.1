Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbYI3EqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbYI3EqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 00:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYI3EqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 00:46:10 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:39919 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750872AbYI3EqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 00:46:09 -0400
Message-ID: <48E1AF0F.8060701@suse.de>
Date: Tue, 30 Sep 2008 08:46:07 +0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Karol Lewandowski <lmctlx@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       linux-kernel@vger.kernel.org
Subject: Re: BUG: Commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a makes special
 keys on my T21 unusable after resume
References: <20080929221628.GA3082@localdomain> <200809300025.52904.rjw@sisk.pl> <20080929234005.GA2616@localdomain>
In-Reply-To: <20080929234005.GA2616@localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Lewandowski wrote:
> On Tue, Sep 30, 2008 at 12:25:52AM +0200, Rafael J. Wysocki wrote:
> 
>> Can you see if the patch at
>> http://bugzilla.kernel.org/attachment.cgi?id=18044&action=view
>> (against current -git) helps?
this patch is not in -rc8, and might even be postponed to 2.6.28-rc1.
> 
> It doesn't help (and -rc8 doesn't help either).
could you please uncomment "#define DEBUG" in the beginning of drivers/acpi/ec.c?
please also open bug report in bugzilla.kernel.org against ACPI and
attach dmesg from working and broken kernel with enabled DEBUG.
Let me know the number of bug report.
Thanks,
Alex.
