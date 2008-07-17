Return-Path: <linux-kernel-owner+w=401wt.eu-S1757939AbYGQN4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939AbYGQN4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 09:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbYGQNzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 09:55:50 -0400
Received: from wx-out-0506.google.com ([66.249.82.239]:42527 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937AbYGQNzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 09:55:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Pxj+nQQitmBiFuVm7X3BuLBVvilUIhxulh1icilyZScDjMQe7o3eucLCEWJU1qsFVG
         kZmFuT8bCywJGEnSwwHFT5YKdAhdawIVVIjSaanXUU07+czV73AcffI7SE5nCRqCcWIm
         cJpkxLtdwRHCpalYWsfT+LkBYvxnCulvjFddw=
Message-ID: <170fa0d20807170655y6cb7df7eh6aae8c727b7b0bb@mail.gmail.com>
Date: Thu, 17 Jul 2008 09:55:45 -0400
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Cc: "Jeff Moyer" <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ext4@vger.kernel.org
In-Reply-To: <yq1iqwhia2m.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1212814533@sermon.lab.mkp.net>
	 <x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
	 <yq1iqwhia2m.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2008 at 11:28 AM, Martin K. Petersen
<martin.petersen@oracle.com> wrote:
>>>>>> "Jeff" == Jeff Moyer <jmoyer@redhat.com> writes:
>
> Jeff> Thanks for all of the great documentation.  It would be good to
> Jeff> include some instructions on how one would test this, and what
> Jeff> testing you performed.
>
> modprobe scsi_debug dix=199 dif=1 guard=1 dev_size_mb=1024 num_parts=1
>
> I'm testing with XFS and btrfs.  Generally doing kernel builds, etc.
> ext2/3 are still problematic because they modify pages in flight.

Have you made the ext2/3/4 developers aware of this?

Could you elaborate on the interaction between the data integrity
support in the block layer and a given filesystem?  Shouldn't _any_
filesystem "just work" given that the block layer is what is
generating the checksums and then verifying them on read?

regards,
Mike
