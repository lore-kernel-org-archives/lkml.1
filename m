Return-Path: <linux-kernel-owner+w=401wt.eu-S1756499AbYLFIqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499AbYLFIqw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 03:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYLFIqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 03:46:43 -0500
Received: from one.firstfloor.org ([213.235.205.2]:39315 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYLFIqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 03:46:42 -0500
To: Jeff Arnold <jbarnold@MIT.EDU>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Denys Vlasenko <vda.linux@googlemail.com>, Tim Abbott <tabbott@MIT.EDU>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: [PATCH 1/7] Make section names compatible with -ffunction-sections -fdata-sections
From: Andi Kleen <andi@firstfloor.org>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu>
	<1228521840-3886-2-git-send-email-jbarnold@mit.edu>
Date: Sat, 06 Dec 2008 09:46:58 +0100
In-Reply-To: <1228521840-3886-2-git-send-email-jbarnold@mit.edu> (Jeff Arnold's message of "Fri,  5 Dec 2008 19:03:54 -0500")
Message-ID: <8763lxwv0d.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Arnold <jbarnold@MIT.EDU> writes:

> From: Denys Vlasenko <vda.linux@googlemail.com>
>
> This patch was originally written by Denys Vlasenko, but it has been
> substantially modified by Anders Kaseorg and Tim Abbott to update it
> to apply to the current kernel and fix bugs.  Any bugs were added by
> Anders Kaseorg and Tim Abbott.
>
> The purpose of this patch is to make it possible to build the kernel
> with "gcc -ffunction-sections -fdata-sections".

This patch seems to be a good thing regardless of ksplice or not.
I would suggest to push it separately.

It's quite large and touches a lot of code, so it probably
would require special treatment during a merge window to avoid
conflicts.

-Andi

-- 
ak@linux.intel.com
