Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbXE3VWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbXE3VWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:22:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbXE3VWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:22:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:45033 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325AbXE3VWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:22:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mgiSz/FC91/K1WfqoP2kVcbDVYu5EhSiC1XKqwlRhliBoseoGYcf85B8kfhNR2MkFy3idmAIApH3ZsX7/8l9xOxM1/hUps8bDBWLWXMxfqIdsxZ7jMYMSid8GD1qlVLwue0zOPzxnJPL1HABJnrhrNbsMrDXzf5pOg+8y2rbHGo=
Message-ID: <86802c440705301422h4e1fe90fra5a809cede5903a8@mail.gmail.com>
Date: Wed, 30 May 2007 14:22:15 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: Re: kexec and aacraid broken
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FB1@otce2k301.adaptec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070529191347.9b1edd8b.akpm@linux-foundation.org>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FB1@otce2k301.adaptec.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Salyzyn, Mark <mark_salyzyn@adaptec.com> wrote:
> I believe this issue is a result of the aacraid_commit_reset patch (as
> posted for scsi-misc-2.6, enclosed to permit testing) not yet propagated
> to the 2.6.22-rc3 tree.
>
> This is the adapter taking longer than 3 minutes to start after a reset.
> I seriously doubt either of these patches suggested below will have an
> affect. And if they do, they are not root cause, one reduces the chances
> that the card will be reset during initialization (thus applied would
> likely mitigate this problem), the other prevents a panic when the
> Adapter is reset (removed, would result in dogs and cats sleeping with
> each other).
>
> Please use kernel parameter aacraid.startup_timeout=540 (merely larger
> than the default 180 seconds) when spawning the kexec or see if the
> aacraid_commit_reset.patch resolves the issue to confirm my hunch.
>

aacraid_commit_reset.patch is in the mainline already.

YH
