Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYJHAC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYJHAC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754179AbYJHABp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:01:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.187]:17779 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038AbYJHABn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:01:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nL/31ly049S4DlAOAKktrgaK0cVFkr0A4Vahegx92SbcXHFmL7dJuA/rnNlfNfO8l1
         Kbw3/MDcBR3Ht6MqUKGyVEhAVcdERFhKBQFm+6xo7gBUSNRInhI4uoOYYainjv6F/Aqi
         nctpe7nKkLQfUs2M7w/kfhkdXs+YFjPP2f9KA=
Message-ID: <48EBF7F7.8080908@gmail.com>
Date: Wed, 08 Oct 2008 08:59:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linda Walsh <smartmontools@tlinx.org>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [smartmontools-support] inactive SATA drives won't stay in standby
 or sleep, PATA models did. (fwd)
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com> <48EAAF2E.4060407@tlinx.org> <48EAB672.3010209@gmail.com> <48EABD07.6030506@tlinx.org> <48EABE8E.9070809@gmail.com> <48EBE263.8000500@tlinx.org>
In-Reply-To: <48EBE263.8000500@tlinx.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> Tejun Heo wrote:
>> Linda Walsh wrote:
>>  
>>> Controller is a Promise TX4/300
>>> Yeap.  After the drive goes offline, does unplugging and replugging
>>> the power cable to the harddrive makes it come back?
>>>     
> ----
>    No.  It hangs the computer. about 2-3 seconds after plugging the
> drives back in.  Did it twice to verify it wasn't a fluke.  Verified
> drives removed from /dev, then
> plugged them back in -- was able to do about 1-2 ls commands on /dev, then
> keyboard goes dead.
> 
>    First time I tried unplugging the power cables and replugging --
> that hung...
> 2nd time tried unplugging a sata cable and replugging -- that hung too.

Ah.. okay, so the controller went bonkers then.  Any chance you can
shell out ~15 bucks and try a sil SATA controller?

>    Hopefully you won't need any more tests of this exact nature...? :-)

Wasn't it fun and empowering?  :-P

-- 
tejun
