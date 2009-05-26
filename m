Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZEZGNs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZEZGNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 02:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbZEZGNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 02:13:42 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:62090 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbZEZGNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 02:13:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jKfuujLW0nlHz37Ad1J6E6vPwdKvLt1BOtzhSU/tZOemLFs9bfB+v/9T4GIfZ+HNn8
         qwrf283C0u+q6LAed+NeK23HdSzlHKaqRa2MfDNkMuIhm1Yy2qXB9lUzE67yjXlvnWeH
         vYCAJ7v1zw5ol/u0So6gbffMWu2J6WdTJnwkY=
Message-ID: <4A1B8873.1040101@gmail.com>
Date: Tue, 26 May 2009 08:13:07 +0200
From: Niel Lambrechts <niel.lambrechts@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1pre) Gecko/20090521 Shredder/3.0b3pre
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "linux.kernel" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: 2.6.29 regression: ATA bus errors on resume
References: <clqON-2Xv-7@gated-at.bofh.it>	<clqON-2Xv-9@gated-at.bofh.it>	<clqON-2Xv-11@gated-at.bofh.it>	<clqON-2Xv-13@gated-at.bofh.it>	<clqON-2Xv-15@gated-at.bofh.it>	<clqON-2Xv-17@gated-at.bofh.it>	<clqON-2Xv-19@gated-at.bofh.it>	<clqON-2Xv-5@gated-at.bofh.it>	<cmknZ-8lW-9@gated-at.bofh.it>	<cmoBl-6Ok-21@gated-at.bofh.it>	<cmp4n-7rb-15@gated-at.bofh.it>	<cmsYg-5BR-27@gated-at.bofh.it>	<cmvW7-1Yj-23@gated-at.bofh.it>	<cnheh-3vO-7@gated-at.bofh.it>	<cnPg1-7Q4-19@gated-at.bofh.it>	<cnTWo-7bV-25@gated-at.bofh.it>	<co1Kd-350-5@gated-at.bofh.it>	<co2Qf-4QQ-27@gated-at.bofh.it>	<co4yj-7Mc-5@gated-at.bofh.it>	<cp71c-4py-29@gated-at.bofh.it>	<cEVyE-re-1@gated-at.bofh.it>	<4A17C39E.2030302@gmail.com>	<4A19F006.3000303@kernel.org> <20090525091534.13ae103c@lxorguk.ukuu.org.uk> <4A1B164B.1010108@gmail.com> <4A1B76EB.9040500@kernel.org> <4A1B8193.1010703@gmail.com> <4A1B8328.80801@kernel.org>
In-Reply-To: <4A1B8328.80801@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2009 07:50 AM, Tejun Heo wrote:
> Niel Lambrechts wrote:
>    
>> Urgh. My root file-system is mounted with extents on, I would have to
>> re-install entirely.
>>
>> I'm wondering why no one else is complaining, or whether the problem is
>> limited to ICH9M/M-E controllers with EXT4 or a certain type of
>> hard-drive. The laptop is a Lenovo W500 (fairly similar to T500), so
>> maybe not a lot of people with this type of controller is using EXT4 yet.
>>      
> The double PHY events are not too rare but it's not too frequent
> either.  The number of people using ext4 on machines which have such
> issues and are regularly suspending and resuming might not be too
> high.
>
>    
>> Anyhow, I think Theodore may have ruled this out as a EXT4 problem
>> already (I first copied him) so I'm not sure what to do now, it will
>> take some strong will (and even more time) for me to re-install EXT3. I
>> just shouldn't have to, dammit. :-p
>>      
> Well, that is a pretty easy way to rule out many possibilities from my
> point of view. :-p If it's difficult, we can try to find out where the
> flag is being set with debug patches.
>    

If you send some patches I'll make every effort to test, it beats having 
to re-install, my installation is just too customized. :)

Regards,
Niel

