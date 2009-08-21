Return-Path: <linux-kernel-owner+w=401wt.eu-S1754884AbZHUHBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbZHUHBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 03:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754751AbZHUHBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 03:01:52 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:63029 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684AbZHUHBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 03:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TSj+8fP3QpU4+kamKuc4V2ZLoBnOh/qryzj/2ARhst6cZ2catyH+6yJUzlefR3jOOc
         p3kl29BXHpRM8yIdQy368lNjq4Eqb5L/RbR4FbZaU01BZyObsGcYJWoGC+HNTSq9v8ht
         XopXM6vut5b0PWtcik9KU16x81DWikqmm2UF0=
MIME-Version: 1.0
In-Reply-To: <20090820.235219.74114618.davem@davemloft.net>
References: <200908210829.10471.elendil@planet.nl> <4A8E3FC1.50201@redhat.com>
	 <200908210848.39377.elendil@planet.nl>
	 <20090820.235219.74114618.davem@davemloft.net>
Date: Fri, 21 Aug 2009 00:01:51 -0700
X-Google-Sender-Auth: da61b9790be26ec5
Message-ID: <9929d2390908210001w10423b51mb460819bb59d7d77@mail.gmail.com>
Subject: Re: [PATCH,v2] Re: e1000e: why does pci_enable_pcie_error_reporting() 
	fail on my hp2510p?
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: David Miller <davem@davemloft.net>
Cc: elendil@planet.nl, dfeng@redhat.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 23:52, David Miller<davem@davemloft.net> wrote:
> From: Frans Pop <elendil@planet.nl>
> Date: Fri, 21 Aug 2009 08:48:38 +0200
>
>> From: Frans Pop <elendil@planet.nl>
>> Subject: net: Don't report an error if devices don't support AER
>>
>> The only error returned by pci_{en,dis}able_pcie_error_reporting() is
>> -EIO which simply means that Advanced Error Reporting is not supported.
>> There is no need to report that, so remove the error check from e1001e,
>> igb and ixgbe.
>>
>> Signed-off-by: Frans Pop <elendil@planet.nl>
>
> Intel folks, just let me know what you want me to do with this,
> if anything.
>
> Thanks.
> --

I will add it to my queue of patches.  I would like to have Emil touch
test this patch at least before pushing the patch to Dave.

-- 
Cheers,
Jeff
