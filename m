Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbXGaNYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbXGaNYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760223AbXGaNY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:24:26 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:12476 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760035AbXGaNYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:24:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CdQfbMy3T/QiwICnwtSfJKei9WmU2bJ3J8RRRXPRalbnwYUBSa5lnJFFmkR83gAYRcNpFgiYLPtUe2ukfOAna1wff9liXPGdXEaXGvh7YvEptV1vQ2EtU7xSZieiM58pUeNI7/RNf6718ZxoFc+d2ySoSGkpNkUM7+lDMWyvh3k=
Message-ID: <46AF3803.1010308@gmail.com>
Date: Tue, 31 Jul 2007 22:24:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu
Subject: Re: [PATCHSET 2.6.23-rc1] sysfs: locking fix and cleanups
References: <11858769082982-git-send-email-htejun@gmail.com> <20070731145506.3c7d4a40@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070731145506.3c7d4a40@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Tue, 31 Jul 2007 19:15:08 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Hello, all.
>>
>> This patchset contains a locking fix and cleanup patches for sysfs.
>>
>> #01	locking fix
>> #02	shadow support removal from Eric adapted to apply after #01
>> #03-07	clean up patches
>>
>> #01 should go mainline as it fixes a locking regression introduced by
>> -rc1 merge.  The rest should stay in -gregkh till 24 merge window
>> opens up.
>>
>> Clean up patches don't introduce any noticeable behavior change.  They
>> just refactor and simplify codes.
>>
>> Thanks.
> 
> FYI: This seems to work well on s390 so far, when attaching/detaching
> and moving devices (my standard test cases ;)

Thanks a lot for testing as always.  :-)

-- 
tejun
