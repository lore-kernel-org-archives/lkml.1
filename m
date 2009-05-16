Return-Path: <linux-kernel-owner+w=401wt.eu-S1757573AbZEPNsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbZEPNsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 09:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbZEPNse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 09:48:34 -0400
Received: from mail-pz0-f115.google.com ([209.85.222.115]:41674 "EHLO
	mail-pz0-f115.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953AbZEPNsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 09:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=dy4DzlDoQE4rhh04yC7uMYXKdV6q+4DxmJtl6CzlpkZRi7Ya4H1t70ZB6CkPoIiSAv
         nDDBjtyjriYggWRPlYpUmj6jaDS4YNmxevEyVytVRB0uhrdaA9CvrgXzXItOewlMIEGP
         WYSvtDzcwhWlvdcEY3+IpKYzN/WHJYXzSVMjs=
Message-ID: <4A0EC42D.2080905@gmail.com>
Date: Sat, 16 May 2009 22:48:29 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Pete Zaitcev <zaitcev@redhat.com>, Eric Moore <Eric.Moore@lsi.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH block#for-2.6.31 2/3] block: set rq->resid_len to blk_rq_bytes()
 on issue
References: <4A0D86DB.9000203@kernel.org> <4A0D87D2.7090806@gmail.com> <4A0D8C73.50208@ru.mvista.com> <4A0DEA33.5050905@gmail.com> <4A0EB1AD.6050806@ru.mvista.com>
In-Reply-To: <4A0EB1AD.6050806@ru.mvista.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sergei.

Sergei Shtylyov wrote:
>> Heh... there's a reason I mentioned the original commit.  The original
>> code was
>>
>>     if (ret > 0) {
>>         /* positive number is the untransferred residual */
>>         rsp->data_len = ret;
>>         req->data_len = 0;
>>         ret = 0;
>>     } else if (ret == 0) {
>>         rsp->data_len = 0;
>>         req->data_len = 0;
>>     }
>>   
> 
>   But still,
> 
>                req->data_len = 0;
> 
> is common between both branches, so could be moved after the *if*
> statement.

Yeah, sure, feel free to submit a patch, but I don't know.  Does it
even matter at all as long as the intention is clear?

Thanks.

-- 
tejun
