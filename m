Return-Path: <linux-kernel-owner+w=401wt.eu-S1753360Ab0ADKrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0ADKrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 05:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0ADKrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 05:47:48 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:40555 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab0ADKrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 05:47:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=CeczQjNU6wA1iBjHE5Ym3M0/xyYfSutk5tr8+8AwpMqQiVE0eltFHXNj6oYO12Q4Nk
         NKnln7q5TvzKqq6dtoL3COnQa+daHHXZvkXmSt+RnrJ/sSrQMeNZo48rs6i3iJOL1/YN
         1p4iNxsZVSKP9dKBuCMzB/aiU6KYdS9JqP2Ug=
Message-ID: <4B41C750.9080305@gmail.com>
Date: Mon, 04 Jan 2010 11:47:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-16.1 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Neil Horman <nhorman@tuxdriver.com>
Subject: [PULL] pull request for limits FIXES for 2.6.33-rc
References: <4B1D32D1.4090404@gmail.com> <4B1FF9A1.2040305@gmail.com>
In-Reply-To: <4B1FF9A1.2040305@gmail.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2009 08:25 PM, Jiri Slaby wrote:
> The following changes since commit 2588465badb648a50cd19623f0dd0063c90d4e31:
>   Linus Torvalds (1):
>         Merge branch 'bkl-arch-for-linus' of
> git://git.kernel.org/.../tip/linux-2.6-tip
> 
> are available in the git repository at:
> 
>   git://decibel.fi.muni.cz/~xslaby/linux writable_limits

So this seems not to not be in 2.6.33 at all, could you pull at least fixes?

The following changes since commit 45d28b097280a78893ce25a5d0db41e6a2717853:
  Linus Torvalds (1):
        Merge branch 'reiserfs/kill-bkl' of
git://git.kernel.org/.../frederic/random-tracing

are available in the git repository at:

  git://decibel.fi.muni.cz/~xslaby/linux limits_fixes

Jiri Slaby (2):
      SECURITY: selinux, fix update_rlimit_cpu parameter
      resource: move kernel function inside __KERNEL__

 include/linux/resource.h |    8 ++++++--
 security/selinux/hooks.c |    2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)




Or better even with rlimit helpers added so that people may start using
those:

The following changes since commit 45d28b097280a78893ce25a5d0db41e6a2717853:
  Linus Torvalds (1):
        Merge branch 'reiserfs/kill-bkl' of
git://git.kernel.org/.../frederic/random-tracing

are available in the git repository at:

  git://decibel.fi.muni.cz/~xslaby/linux limits_cleanup

Jiri Slaby (3):
      SECURITY: selinux, fix update_rlimit_cpu parameter
      resource: move kernel function inside __KERNEL__
      resource: add helpers for fetching rlimits

 include/linux/resource.h |    8 ++++++--
 include/linux/sched.h    |   22 ++++++++++++++++++++++
 security/selinux/hooks.c |    2 +-
 3 files changed, 29 insertions(+), 3 deletions(-)




I'll reply to this message with the 3 patches.

thanks,
-- 
js
