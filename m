Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbYGVIBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbYGVIBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752412AbYGVIBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:01:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:34304 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYGVIBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:01:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=M5NkN5zVw3uNWQl17on5Jpkj/9K0CQ+o3hg7Qmz4/D6FHz81kphmZkSc+9Dpu190J8
         9uAsOntLjy74zFhtYkCF3eR4q9dj45QyS/Asd3uD4WBEH0gTwVSfaFsZjXA1YU8Dyyoy
         f4DXf8vUgG44r92Zk5yzm+/fUfqVFM3JB0s6M=
Message-ID: <d82e647a0807220101q43da5bf3p43312cacb2f90c76@mail.gmail.com>
Date: Tue, 22 Jul 2008 16:01:40 +0800
From: "Ming Lei" <tom.leiming@gmail.com>
To: "Rami Rosen" <roszenrami@gmail.com>
Subject: Re: BUG: iwlwifi build failed
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <b25312890807220042i66fce3coe4947b569c335b5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d82e647a0807212143r2f598a59y76a79fd9bb8f17@mail.gmail.com>
	 <b25312890807220042i66fce3coe4947b569c335b5b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/22 Rami Rosen <roszenrami@gmail.com>:
> Hi,
>  - This problem was reported and a patch was sent recently; probably
> it is not yet in your tree yet.

yes, I am using linus tree.

>
>  - I assume that your .config file does not have CONFIG_IWLWIFI_DEBUG set.
> On the net-2.6 current tree, when you **do** set the
> CONFIG_IWLWIFI_DEBUG, this problem does not occur
> (and, as can be understood, when CONFIG_IWLWIFI_DEBUG
> is not set, it does occur).

yes.

>
> So, if it is possible for you for the time being, till this patch
> finds its way into the tree, I suggest that you
> might set the CONFIG_IWLWIFI_DEBUG and run make.
>
> More details on this patch you can find here:
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2008-07/msg09132.html
>
> Regards,
> Rami Rosen
>
>
> On Tue, Jul 22, 2008 at 7:43 AM, Ming Lei <tom.leiming@gmail.com> wrote:
>> commit 93ded9b8fd42abe2c3607097963d8de6ad9117eb
>> Merge: 6d52dcb... f756cbd...
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Mon Jul 21 15:42:20 2008 -0700
>> =====================================
>>
>> drivers/net/wireless/iwlwifi/iwl-led.c: In function 'iwl_led_brightness_set':
>> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: 'led_type_str'
>> undeclared (first use in this function)
>> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: (Each undeclared
>> identifier is reported only once
>> drivers/net/wireless/iwlwifi/iwl-led.c:198: error: for each function
>> it appears in.)
>> make[4]: *** [drivers/net/wireless/iwlwifi/iwl-led.o] Error 1
>> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>>
>>
>> --
>> Lei Ming
>> --
>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>



-- 
Lei Ming
