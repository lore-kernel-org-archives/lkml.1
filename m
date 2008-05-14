Return-Path: <linux-kernel-owner+w=401wt.eu-S1761449AbYENBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761449AbYENBBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757536AbYENBBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 21:01:05 -0400
Received: from sous-sol.org ([216.99.217.87]:38256 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757445AbYENBBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 21:01:04 -0400
Date: Tue, 13 May 2008 17:52:38 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: KaiGai Kohei <kaigai@ak.jp.nec.com>
Cc: Chris Wright <chrisw@sous-sol.org>, greg@kroah.com, morgan@kernel.org,
       serue@us.ibm.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] exporting capability name/code pairs (for 2.6.26)
Message-ID: <20080514005238.GZ17453@sequoia.sous-sol.org>
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com> <20080423053726.GF3861@localhost.localdomain> <480EE1F6.3070205@ak.jp.nec.com> <482A33FA.5030109@ak.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <482A33FA.5030109@ak.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KaiGai Kohei (kaigai@ak.jp.nec.com) wrote:
> Chris, what is the status of the patch?

I still don't understand how ...

>> When we run a userspace utility on the latest kernel, it has to be compiled
>> with kernel-headers which have same capability set at least.
>> If installed userspace utility does not support newly added capabilities,
>> it requires users to rebuild their utilities when they update the kernel.
>>
>> Typically, kernel developer faces this kind of version mismatching.
>> When they boots their kernel with new capabilities, it also requires to
>> rebuild libcap. Then, they have to revert it, when they boots with normal
>> kernel.
>>
>> If libcap can know what capabilities are supported on the running kernel
>> automatically, it does not need users to rebuild libcap concurrently.

...libcap can do anything meaningful here with capabilities it doesn't
know about?  This interface is already versioned, what is wrong is old
cap version on new kernel (clearly new cap version on old kernel would
have to fall back to older cap version)?

thanks,
-chris
