Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbZLEBVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbZLEBVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932664AbZLEBVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:21:24 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:43777 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932656AbZLEBVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:21:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XTtNdfELUlhjRc21YE1CgHzgAm64+9Z6qi2P5HxdnxJasStx/45Jni03dy/Pr5bvqQ
         GEjsaF7xHc7jb5Mlb4I+O2XAZFpXli2UFbLRxw/ovwwGka/Ot8fSMhcZOd+FokLMPRv6
         FDfQWvd+EXUH1FqEsiRsMlXKBXdd2psT6woHw=
MIME-Version: 1.0
In-Reply-To: <4B19B4FA.5080904@gmail.com>
References: <4B198670.2000406@gmail.com> <4B198A33.7080705@gmail.com>
	 <4B19A337.6060808@gmail.com>
	 <20091205114048.37df384e.sfr@canb.auug.org.au>
	 <4B19B4FA.5080904@gmail.com>
Date: Fri, 4 Dec 2009 17:21:29 -0800
X-Google-Sender-Auth: be257a06ed166f1f
Message-ID: <9929d2390912041721g185d5f95s809a80811d2ac292@mail.gmail.com>
Subject: Re: [PATCH 06/31] Constify struct e1000_mac_operations for 2.6.32 v1
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Emese Revfy <re.emese@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, jesse.brandeburg@intel.com,
       bruce.w.allan@intel.com, peter.p.waskiewicz.jr@intel.com,
       john.ronciak@intel.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/4 Emese Revfy <re.emese@gmail.com>:
> Stephen Rothwell wrote:
>> Hi Emese,
>>
>> On Sat, 05 Dec 2009 01:03:03 +0100 Emese Revfy <re.emese@gmail.com> wrote:
>>> --- a/drivers/net/e1000e/82571.c
>>> +++ b/drivers/net/e1000e/82571.c
>>> @@ -212,6 +212,7 @@ static s32 e1000_init_mac_params_82571(struct e1000_adapter *adapter)
>>>  {
>>>      struct e1000_hw *hw = &adapter->hw;
>>>      struct e1000_mac_info *mac = &hw->mac;
>>> +    /* cannot be const */
>>>      struct e1000_mac_operations *func = &mac->ops;
>>
>> Adding to the comment to say why it can't be const may allow us to fix
>> this later ...
>
> Ok, in the next patch series I will explain each case.
> --

Also, please sync up your patches with what is in Dave's net-next-2.6
tree, because some of the changes made no longer apply since the code
was either changed or removed.

-- 
Cheers,
Jeff
