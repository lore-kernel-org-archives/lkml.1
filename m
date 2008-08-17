Return-Path: <linux-kernel-owner+w=401wt.eu-S1754540AbYHQQVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540AbYHQQVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 12:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751671AbYHQQU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 12:20:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:11092 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbYHQQU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 12:20:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lYnVdDBtosJSl5Sm2+/5Ma9pzc7tEsQncOxmUO9+jBjmFiGoZkvosUOsDkBJzOXlAc
         Q/WVuyF/3lfEmoM3F/nf/u3FCAWgtXoyXbhULM7IhzrLglQAymkPmDgndORqS7o6/mCX
         vBoKOOvopkSa9IXVqzTz8SpF8IEA+PT9bqcaI=
Message-ID: <1ba2fa240808170920r67e11567h2da8b396b18729dd@mail.gmail.com>
Date: Sun, 17 Aug 2008 19:20:54 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: CPU load after killing iwlagn with RF kill switch
Cc: "Mirco Tischler" <mt-ml@gmx.de>,
       "Leonid Podolny" <leonidp.lists@gmail.com>,
       linux-kernel@vger.kernel.org, yi.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       IvDoorn@gmail.com
In-Reply-To: <20080817150242.GA23926@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48A5EC02.4070303@gmail.com>
	 <20080817035921.4d35ae0e@mtlp.12thdimension>
	 <1ba2fa240808170004p63b76db1l1fdfb1cf1cb41636@mail.gmail.com>
	 <20080817150242.GA23926@tuxdriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 6:02 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Sun, Aug 17, 2008 at 10:04:12AM +0300, Tomas Winkler wrote:
>
>> There is gap in current rfkill implementation that we didn't close
>> yet.  There were also few patches that were not signed by Intel and
>> are apparently wrong.
>
> Can you be more specific?  Do you know which patches are wrong (even
> if you don't know how to fix them)?
>

80fcc9e28cf3a209fbfb39a7bbddc313c59c7424
This one  is wrong and there are more then are not acked even though
they cause no problem. In general I would prefer that patches will be
acked by Yi or me.
I will try to rebase our rfkill fixes ASAP from iwlwifi-2.6. iwl5000 branch.

Thanks
Tomas
