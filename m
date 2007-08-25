Return-Path: <linux-kernel-owner+w=401wt.eu-S1764464AbXHYNAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764464AbXHYNAY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 09:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXHYNAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 09:00:12 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44886 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbXHYNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 09:00:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, samuel@sortiz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] sysctl: Properly register the irda binary sysctl numbers.
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<23568.1187876026@turing-police.cc.vt.edu>
	<20070823141652.d488a6e0.akpm@linux-foundation.org>
	<m1wsvlmvu6.fsf_-_@ebiederm.dsl.xmission.com>
	<6634.1188030574@turing-police.cc.vt.edu>
Date: Sat, 25 Aug 2007 06:57:17 -0600
In-Reply-To: <6634.1188030574@turing-police.cc.vt.edu> (Valdis Kletnieks's
	message of "Sat, 25 Aug 2007 04:29:34 -0400")
Message-ID: <m16433n55e.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu writes:

> On Thu, 23 Aug 2007 21:53:53 MDT, Eric W. Biederman said:
>> 
>> Grumble.  These numbers should have been in sysctl.h from the
>> beginning if we ever expected anyone to use them.  Oh well put
>> them there now so we can find them and make maintenance easier.
>> 
>> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
>
> Applied both patches, and now all I get from irda at boot time now is this:
>
> [  292.062000] irda_init()
> [  292.063000] NET: Registered protocol family 23
> [  292.069000] IrCOMM protocol (Dag Brattli)
> [  292.221000] PPP generic driver version 2.4.2
>
> in other words, business as usual. Thanks.
>
> Feel free to stick this on both patches:
>
> Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

Thanks.

It's good to have confirmation that my sysctl_check routine
didn't find something else wrong.

Eric
