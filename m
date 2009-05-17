Return-Path: <linux-kernel-owner+w=401wt.eu-S1752200AbZEQLrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbZEQLrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 07:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751270AbZEQLqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 07:46:49 -0400
Received: from mail-px0-f191.google.com ([209.85.216.191]:52897 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbZEQLqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 07:46:47 -0400
X-Greylist: delayed 324 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 May 2009 07:46:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Uk2Gh3P53x5JUsuga6fOcMyutEmU1cDYsyHImN3YCXoZBOS7KrDhTaLtUIemp1UicU
         hrwwxIl7Kn+/YJYh+62PCcOf0e0y3N+ub47suxI+UaAYFybLwTT4NAUVIOrdOIMLRpF1
         kvK45OVWH/j+4vYUbWxbsHv2p9cgP83hFXR/0=
Message-ID: <4A0FF7DE.7030303@gmail.com>
Date: Sun, 17 May 2009 20:41:18 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Pete Zaitcev <zaitcev@redhat.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Eric Moore <Eric.Moore@lsi.com>, "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH UPDATED block#for-2.6.31 2/3] block: set rq->resid_len
 to blk_rq_bytes() on issue
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0E0650.1020500@gmail.com> <4A0FCF52.7070406@panasas.com> <4A0FF5EA.3020805@gmail.com>
In-Reply-To: <4A0FF5EA.3020805@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> I think I'll just add resid_len adjustment there right after
> __data_len manipulation.  That code path should really go away
> eventually.

Aieee... crap, I also forgot the merging path.  I'll change as you
suggested.  Thanks.

-- 
tejun
