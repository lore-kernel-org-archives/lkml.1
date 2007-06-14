Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbXFNH5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbXFNH5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 03:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbXFNH4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 03:56:52 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:24567 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752649AbXFNH4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 03:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=CKMBYztX3IkJ0Pul8eqNnJHfxnqpo2ZL7faUOrVg6vwy3TM7XYm8VZoGh6MmVA1CJsBjTURlAOXhNWxy8yLNjqtRHTR4uEaSDH5MBjkXqmW3SZ2HKbSCAFCzml6b56p1+LsNgM7/7g8Cxzi8c/K/HQfv1ByhyBGMZs5+W18ESIc=
Message-ID: <4670F4BB.3060306@gmail.com>
Date: Thu, 14 Jun 2007 16:56:43 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
CC: Pavel Machek <pavel@ucw.cz>, Arjan van de Ven <arjan@linux.intel.com>,
       jeff@garzik.org, james.bottomley@steeleye.com,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 0/3] AHCI Link Power Management
References: <20070611114600.7fca1c24.kristen.c.accardi@intel.com>	<466DFDB5.9030901@gmail.com>	<466E0642.5020506@linux.intel.com>	<466E1D51.9070007@gmail.com>	<20070613090430.GK13747@elf.ucw.cz> <20070613092607.4ddf0f79.kristen.c.accardi@intel.com>
In-Reply-To: <20070613092607.4ddf0f79.kristen.c.accardi@intel.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kristen Carlson Accardi wrote:
>>>>> I'm not sure about this.  We need better PM framework to support 
>>>>> powersaving in other controllers and some ahcis don't save much
>>>>> when only link power management is used,
>>>> do you have data to support this?
>>> Yeah, it was some Lenovo notebook.  Pavel is more familiar with the
>>> hardware.  Pavel, what was the notebook which didn't save much power
>>> with standard SATA power save but needed port to be completely turned off?
>> Thinkpad x60. Some one Kristen probably used while developing the
>> patch :-).
> 
> Yes - that confirms my conclusion that the first patch just wasn't
> done correctly - cause when I measure the power savings with a power
> meter on the X60 with my patches I see ~ 1W.

Hmmm... Could it be that the controller doesn't enter powersave state
when SControl is written to?

-- 
tejun
