Return-Path: <linux-kernel-owner+w=401wt.eu-S1758025AbYHUHoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758025AbYHUHoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 03:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753571AbYHUHoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 03:44:00 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35391 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYHUHoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 03:44:00 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20080727012212.GW28946@ZenIV.linux.org.uk>
Date: Thu, 21 Aug 2008 00:40:03 -0700
In-Reply-To: <20080727012212.GW28946@ZenIV.linux.org.uk> (Al Viro's message of
	"Sun, 27 Jul 2008 02:22:12 +0100")
Message-ID: <m1d4k2zui4.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@ZenIV.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [git pull] VFS patches, the first series
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> The first part of huge pile.  Mostly it's untangling nameidata handling,
> digging towards the pieces that kill intents and cleaning pathname
> resolution in general.  ->permission() sanitizing and sysctl procfs
> treatment rewrite needed for it.  A bunch of descriptor handling fixes.
> Plus part of assorted patched from the last cycle sent by other folks.
> A _lot_ more is still pending; this is what I'd managed to pull into
> a series by this point.  Please, pull from
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6.git/ for-linus

Al a quick heads up.  In testing movement of network devices between
namespaces  I hit the recently added WARN_ON in unregister_sysctl_table.

More tomorrow when I get a after I have dug into this farther.

Eric
