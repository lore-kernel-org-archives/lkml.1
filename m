Return-Path: <linux-kernel-owner+w=401wt.eu-S1751800AbZL2SEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800AbZL2SEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 13:04:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751760AbZL2SEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 13:04:47 -0500
Received: from one.firstfloor.org ([213.235.205.2]:50936 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbZL2SEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 13:04:47 -0500
To: Quentin Barnes <qbarnes+nfs@yahoo-inc.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [RFC][PATCH] Disabling read-ahead makes I/O of large reads small
From: Andi Kleen <andi@firstfloor.org>
References: <20091225000717.GA26949@yahoo-inc.com>
Date: Tue, 29 Dec 2009 19:04:43 +0100
In-Reply-To: <20091225000717.GA26949@yahoo-inc.com> (Quentin Barnes's message of "Thu, 24 Dec 2009 18:07:17 -0600")
Message-ID: <87aax18xms.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quentin Barnes <qbarnes+nfs@yahoo-inc.com> writes:

cc fengguang who is Mr.Readahead. The full description+patch
is in the archives.

> In porting some application code to Linux, its performance over
> NFSv3 on Linux is terrible.  I'm posting this note to LKML since
> the problem was actually tracked back to the VFS layer.
[...]
> I have no idea if my patch is the appropriate fix.  I'm well out of
> my area in this part of the kernel.  It solves this one problem, but
> I have no idea how many boundary cases it doesn't cover or even if
> it is the right way to go about addressing this issue.
>
> Is this behavior of shorting I/O of read(2) considered a bug?  And
> is this approach for a fix approriate?

It sounds like a (performance) bug to me.

>From a quick look your fix looks reasonable to me.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
