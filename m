Return-Path: <linux-kernel-owner+w=401wt.eu-S1761301AbXI1O3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301AbXI1O3N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:29:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755354AbXI1O26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:28:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:12243 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbXI1O25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:28:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=EVzWMmnxXBD43pW6sSOFGe+4ANMrNWcmQjz5bOZS9s7IgpsyRmEGNZzk7Wz78iEHlhsaB5xVjETHNhnSWz8VHX8sUe49c4cE0HruIWqgPNwMiL7VOd5Zuz0vCMWWf9794Ox2BMGmTtwjCssStu6BZYcBwKJ5v/tS9WOVcbTFxak=
Message-ID: <46FD0F3F.8000902@gmail.com>
Date: Fri, 28 Sep 2007 07:27:11 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Cornelia Huck <cornelia.huck@de.ibm.com>
CC: ebiederm@xmission.com, greg@kroah.com, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-kernel@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: [PATCH 4/4] sysfs: make suicidal nodes just do it directly
References: <11902731752407-git-send-email-htejun@gmail.com>	<11902731751771-git-send-email-htejun@gmail.com> <20070928155448.3dedd801@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070928155448.3dedd801@gondolin.boeblingen.de.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck wrote:
> On Thu, 20 Sep 2007 16:26:15 +0900,
> Tejun Heo <htejun@gmail.com> wrote:
> 
>> Sysfs now allows direct suicide.  Make suicidial sysfs nodes to use
>> it and remove now unncessary callback mechanism.
>>
>> Signed-off-by: Tejun Heo <htejun@gmail.com>
>> ---
>>  drivers/base/core.c         |   33 ----------------------
>>  drivers/s390/cio/ccwgroup.c |   25 +++-------------
>>  drivers/scsi/scsi_sysfs.c   |   13 +--------
>>  fs/sysfs/file.c             |   63 -------------------------------------------
>>  include/linux/device.h      |    6 ----
>>  include/linux/sysfs.h       |    9 ------
>>  6 files changed, 6 insertions(+), 143 deletions(-)
> 
> ccwgroup was implicitly relying on a held reference, fix that.
> 
> Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

Thanks.  Will incorporate into the next series.

-- 
tejun
