Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbYENFob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbYENFob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 01:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751801AbYENFoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 01:44:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:16202 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbYENFoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 01:44:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=baezNt5yr6FactBZdcyn0jPkZyiGR0aAx0Q+CISkWsZwueyd+5AQdJ8eRCHiTHxEWCX80RlvykfsbkspOdwvqjGI/azhrorlVzI9H8Hwt28m0JF0vhGkYuyyQySq3c5erXnccLdPPICpuXrV6Lt9SGkv9Dv6h3lZ0xXdceZbhLc=
Message-ID: <482A7C2C.6040302@gmail.com>
Date: Wed, 14 May 2008 14:44:12 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Bruce Allen <ballen@gravity.phys.uwm.edu>
Subject: Re: libata errors with smartctl on 2.6.24, WD3200AAKS and nVidia
 AHCI
References: <200804092130.07149.tvrtko@ursulin.net> <200804130834.14257.tvrtko@ursulin.net> <48041CC1.1030909@gmail.com> <200804150721.17337.tvrtko@ursulin.net>
In-Reply-To: <200804150721.17337.tvrtko@ursulin.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko A. Ursulin wrote:
> On Tuesday 15 April 2008 04:10:57 Tejun Heo wrote:
>> Tvrtko A. Ursulin wrote:
>>> On Sunday 13 April 2008 04:11:15 Tejun Heo wrote:
>>>> Is auto spindown configured for the drive?
>>> I don't think so - it's a 3.5" drive with no special PM features - but
>>> how to tell?
>> Hmm... Can you please post the result of "smartctl --version" and
>> "smartctl -a > out 2>&1" and dmesg after the smartctl command?
> 
> Yep, pasted and attached below. dmesg is 67k, hope list is happy with that.

Thanks for the data.  Nothing really stands out tho.  It looks like the 
drive just doesn't like SMART commands 0xda and 0xd1.  0xda being a 
mandatory non-data command, it failing due to driver problem is unlikely.

Can you please post the result of "hdparm -I /dev/sda" and "lspci -nn"?

Bruce, WDC WD3200AAKS-00VYA0, 12.01B02 is timing out SMART commands 0xda 
and 0xd1 and the reported data seems all wrong.  Does it ring a bell? 
The original thread can be read from the following URL.

   http://thread.gmane.org/gmane.linux.ide/30459

Thanks.

-- 
tejun
