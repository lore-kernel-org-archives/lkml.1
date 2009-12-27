Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbZL0Xou@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbZL0Xou (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 18:44:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZL0Xot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 18:44:49 -0500
Received: from smtp-out2.blueyonder.co.uk ([195.188.213.5]:57698 "EHLO
	smtp-out2.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750935AbZL0Xos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 18:44:48 -0500
Message-ID: <4B37F16D.1040000@blueyonder.co.uk>
Date: Sun, 27 Dec 2009 23:44:45 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-GB; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0 ThunderBrowse/3.2.6.8
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: All kernels after 2.6.32-git10  show only 1 CPU ** Fixed in 2.6.33-rc2
 **
References: <4B324B76.9020901@blueyonder.co.uk> <4B33670C.7050503@blueyonder.co.uk> <4B341149.9010106@blueyonder.co.uk> <4B363EEE.8020108@blueyonder.co.uk> <alpine.LFD.2.00.0912261457550.4089@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912261457550.4089@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/12/09 20:01, Len Brown wrote:
> Sid,
> If the kernel boots properly as of -rc2, then I would not worry
> so much that it was broken at some point during the merge window.
> 
> However, if it is still broken and you need to bisect back
> into -merge to find out what caused it...  note that
> booting with "acpi=ht" may be a useful tool.  For this
> option will boot just enough of ACPI to enumerate processors,
> but no more.  (Of course if this option doesn't boot with
> the previous working kernels, then alas, it will not be useful here)
> 
> cheers,
> Len Brown, Intel Open Source Technology Center
> 
> 
> 

2.6.32-git1 boots OK with 2 CPU's.
2.6.32-git2 boots with "acpi=ht" but only one CPU appears.
With 2.6.32-git2 booted
# git bisect bad
tindog:/usr/src/GIT/linux-git # git bisect good v2.6.32
Bisecting: 4685 revisions left to test after this (roughly 12 steps)
[f6c4c8195b5e7878823caa1181be404d9e86d369] Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jikos/hid

This is where I lose understanding of what I've done as v2.6.32-git1 and
-git2 are not accepted as valid revisions needed by git bisect.
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

