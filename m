Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYJOBgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYJOBgo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 21:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYJOBgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 21:36:36 -0400
Received: from mail.windriver.com ([147.11.1.11]:60537 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbYJOBgf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 21:36:35 -0400
Message-ID: <48F54923.1080904@windriver.com>
Date: Tue, 14 Oct 2008 20:36:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: anils_r@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: kgdb for 2.6.26
References: <444546.96900.qm@web32406.mail.mud.yahoo.com>
In-Reply-To: <444546.96900.qm@web32406.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2008 01:36:33.0443 (UTC) FILETIME=[7497FF30:01C92E66]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anil kumar wrote:
> Hi,
>
> I found that kgdb is now able in kernel 2.6.26. Is there any other patch I need to have kgdb up and running for this kernel like 8250.patch, i386.patch along with this. If so, can you please point me to the location to pick it for this kernel.
>
> with regards,
>   Anil
>
>
>       
>   

If you are looking for other I/O drivers such as the kgdb_8250 module,
you can find the full kgdb patch set (which is not all in the mainline at:

http://git.kernel.org/?p=linux/kernel/git/jwessel/linux-2.6-kgdb.git;a=shortlog;h=kgdb_2.6.26

All that is merged in the 2.6.26 kernel is kgdb core, x86 arch specific
kgdb, and the kgdboc (kgdb over serial console) I/O module.

Cheers,
Jason.
