Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbZDGO63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbZDGO63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 10:58:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758347AbZDGO6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 10:58:16 -0400
Received: from fmailhost04.isp.att.net ([204.127.217.104]:41452 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683AbZDGO6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 10:58:15 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49DB69FA.1060202@lwfinger.net>
Date: Tue, 07 Apr 2009 09:58:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Galbraith <efault@gmx.de>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [2 regressions] Current git cannot find root device on x86-64(HP
 nx6325), NFS broken
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Tue, 2009-04-07 at 00:47 +0200, Rafael J. Wysocki wrote:
>> Hi,
>>
>> Current mainline (commit 22ae77bc7ac115b9d518d5cbc13d39317079b2b0) can't
>> find the root device (it's handled by statically compiled-in sata_sil) and
>> generally causes the "invalid module format" message to appear for all modules
>> loaded from the initrd on my HP nx6325 (the distro is openSUSE 11.1).
>>
>> I don't know which commit might have made this happen, but the breakage was
>> introduced during the last three days (commit
>> 601cc11d054ae4b5e9b5babec3d8e4667a2cb9b5 is certainly good). I'll bisect
>> tomorrow if there are no ideas.

> I bisected "invalid module format" woes to 9cb610d.

My system also fails to load modules from initrd unless 9cb610d is reverted.
Something is wrong with the "module: remove the SHF_ALLOC flag on the __versions
section" patch.

Larry

