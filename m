Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZLCWIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZLCWIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:08:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753632AbZLCWIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:08:23 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:37176 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581AbZLCWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:08:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Hx0CVlJhsmJcB74dknSk3GgvF9p10IKw5BVCHpChyBGR4o8Zlwa6f+TsIGAfqiBuQw
         WVFUD5Tm0ta1Jofm0IvHv61eYyorWFNbeg0YlP32g4BS2mgQolRLJJfB/+USwpl0bY88
         YliJ/acJxJXQnGTiEW+m3cYrMGfWNTT7s9HtA=
Message-ID: <4B1836D5.9010502@garzik.org>
Date: Thu, 03 Dec 2009 17:08:21 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <200912031339.14440.bzolnier@gmail.com> <4B17FB37.2030501@garzik.org> <200912032045.48728.bzolnier@gmail.com> <4B182A9F.5090708@garzik.org> <4B18357E.9050900@ru.mvista.com>
In-Reply-To: <4B18357E.9050900@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 05:02 PM, Sergei Shtylyov wrote:
> Hello.
>
> Jeff Garzik wrote:
>
>>> pata_efar: MWDMA0 is unsupported
>>
>> skipped, pending discussion (just sent email)
>
> There's basically nothing to discuss -- the PIIX like chips don't
> support MWDMA0 (with an acceptable cycle length, if at all, anyway). The
> way the driver is written, MWDMA0 is simply programmed overclocked.
>
>>
>>> pata_hpt3x2n: fix overclocked MWDMA0 timing
>>
>> skipped, pending discussion (just sent email)
>
>
> Nothing to discuss either, this looks like a single digit typo to me...
>
>>
>>> pata_hpt3x3: Power Management fix
>>
>> applied, on a hope and a prayer (did not see this posted to mailing
>> list?).
>
> http://marc.info/?l=linux-ide&m=125916980522990

Yeah, missed that.  Bart provided a link, too.


>>> pata_it8213: MWDMA0 is unsupported
>>
>> skipped, pending discussion (just sent email)
>
> Nothing to discuss...

Perhaps discuss was the wrong word.  After reviewing each thread, in 
each case, it remained unclear whether the original patch was correct or 
not, especially since the docs seemed to list MWDMA0 as supported on 
PIIX-like chips.

Thanks for going over these, that should clear up my confusion.

	Jeff



