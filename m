Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYH0RWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYH0RWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:22:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbYH0RWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:22:25 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43175 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYH0RWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:22:23 -0400
To: Joe Korty <joe.korty@ccur.com>
Cc: Mark Brown <broonie@sirena.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Simon Farnsworth <simon.farnsworth@onelan.com>
Subject: Re: [PATCH] printk timestamp post-boot suppression, v2
From: Andi Kleen <andi@firstfloor.org>
References: <20080827151613.GA10325@tsunami.ccur.com>
	<20080827161621.GF10834@sirena.org.uk>
	<20080827170424.GA17217@tsunami.ccur.com>
Date: Wed, 27 Aug 2008 19:22:17 +0200
In-Reply-To: <20080827170424.GA17217@tsunami.ccur.com> (Joe Korty's message of "Wed, 27 Aug 2008 13:04:25 -0400")
Message-ID: <87od3eqsom.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Korty <joe.korty@ccur.com> writes:

> On Wed, Aug 27, 2008 at 12:16:30PM -0400, Mark Brown wrote:
>> It'd be nicer if this were optional - syslog typically only logs at
>> second resolution and not all systems are going to have logfiles.
>
>
> Optionally suppress printk timestamping after system boot.

Such things shouldn't be CONFIGs, but boot options.

But a better option might be to just fix syslog or klogd to convert those
time stamps into its own ones? Then your screen estate issue
would disappear. That would be a user space fix only.

-Andi

-- 
ak@linux.intel.com
