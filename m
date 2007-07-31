Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbXGaNWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbXGaNWW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbXGaNWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:22:14 -0400
Received: from qb-out-0506.google.com ([72.14.204.234]:13015 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760AbXGaNWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:22:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XDSvdVbSChGMHQlCpPqpREJyvCKDYlGbCxjuFZXzTONcqcOrOYnXwUkK8wVoKEQIHyfKVcBryhmFkFipHDhobKM608tL9YLp1GHmZUwZi/xOKSQ6mh70TVujgPMwLBzI+3wnzVz+CLiWg8M5m0HObWF5wvvwOgq65w5h6BvJNQU=
Message-ID: <46AF377D.4020103@gmail.com>
Date: Tue, 31 Jul 2007 22:22:05 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCH 4/7] sysfs: simplify sysfs_remove_dir()
References: <11858769082982-git-send-email-htejun@gmail.com>	<11858769083860-git-send-email-htejun@gmail.com> <20070731145935.3398cfba@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070731145935.3398cfba@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 31 Jul 2007 19:15:08 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> With the shadow directories gone, sysfs_remove_dir() can be simplified.
>>
>> * parent doesn't need to be grabbed separately.  Just access
>>   old_dentry->d_parent.
>>
>> * parent sd can never change.  Remove code to move under the new
>>   parent.
>>
>> * Massage comments a bit.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>>  fs/sysfs/dir.c |   26 ++++----------------------
>>  1 files changed, 4 insertions(+), 22 deletions(-)
>>
> It's not sysfs_remove_dir(), but sysfs_rename_dir() :) Otherwise this
> looks good.

Yeah, what was I thinking.  :-)

-- 
tejun
