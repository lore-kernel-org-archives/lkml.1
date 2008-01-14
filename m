Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYANXZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYANXZ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 18:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754348AbYANXZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 18:25:51 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754180AbYANXZu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:25:50 -0500
Message-ID: <478BEF7A.5090906@redhat.com>
Date: Mon, 14 Jan 2008 17:25:46 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, zippel@linux-m68k.org
Subject: Re: [PATCH] address hfs on-disk corruption robustness review comments
References: <478BD0D8.8070101@redhat.com> <20080114151659.035b96a3.akpm@linux-foundation.org>
In-Reply-To: <20080114151659.035b96a3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 14 Jan 2008 15:15:04 -0600
> Eric Sandeen <sandeen@redhat.com> wrote:
> 
>> Address Roman's review comments for the previously sent on-disk
>> corruption hfs robustness patch.
>>
>> I still owe a patch for hfsplus.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> That isn't a changlog.  Please send a description of this patch?

Follows.

-----------

Per maintainer's request, use 0 as a failure value, rather than
making a new macro HFS_BAD_KEYLEN, and use a switch statement
instead of if's.

Add new fail: target to __hfs_brec_find to skip assignments using
bad values when exiting with a failure.

-----------

Sorry 'bout that.

-Eric
