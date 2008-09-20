Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbYITEur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbYITEur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 00:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbYITEug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 00:50:36 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:17126 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYITEue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 00:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=iH+YblQbJi1ZoVv8bFBzL3MLS8PI+4tGms1cggMtQQA6EAfWGc9+yt5D58vNM4m629
         +L0GLopNbtjDh5qxZTWj7DmrgohIaQnRw5FFGKWg074y9LQdwu1ENPydNuuKwuUHVfN7
         P/gVGhgaUcRIrZacPw/uBUDMqsGrVzOyw5Ysc=
Message-ID: <48D480B4.3030104@gmail.com>
Date: Fri, 19 Sep 2008 21:48:52 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] libata: Implement disk shock protection support
References: <87d4j2n3dn.fsf@denkblock.local>	<20080917163144.9870.97008.stgit@denkblock.local>	<48D147E2.3020601@gmail.com> <87skrwmpng.fsf@denkblock.local>	<48D3979F.10305@gmail.com> <87ljxokz67.fsf@denkblock.local>	<48D3B3EE.70702@gmail.com> <87fxnwkwov.fsf@denkblock.local>
In-Reply-To: <87fxnwkwov.fsf@denkblock.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
> Tejun Heo <htejun@gmail.com> wrote:
>> Elias Oltmanns wrote:
> Will do. By the way, it's just occurred to me that we really need to
> call complete_all() in ata_scsi_park_store(). So, thanks for making me
> think it all through once more.

Hmmm... just replied to the updated patch.  complete_all() will
potentially overflow the done counter (which BTW is interface problem
in completion) why is it necessary?  (probably best to continue on the
other thread).

Thanks.

-- 
tejun

