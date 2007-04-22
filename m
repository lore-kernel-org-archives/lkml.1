Return-Path: <linux-kernel-owner+w=401wt.eu-S1030900AbXDVOXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030900AbXDVOXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 10:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030901AbXDVOXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 10:23:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:56286 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030900AbXDVOXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 10:23:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LTDqO522KVMhZw7kb8EVyHQGKUrtEOoVWiGrSyoNqhbYYtZoWJR2EBb1aeADu0AcNri3UPDt4Z2ZSTUGS2fI0Bs3+kSYbRNjuAWQFD5CLUWQDc4eGUDdkJDq4gMC6T5zBWQcuACRmOVF16njhVzPXs3eVREMkSdzvtORL15cSxA=
Message-ID: <8355959a0704220723s796fa414xec43cf3ac1036502@mail.gmail.com>
Date: Sun, 22 Apr 2007 19:53:13 +0530
From: "Sunil Naidu" <akula2.shark@gmail.com>
To: "Mark Lord" <lkml@rtr.ca>
Subject: Re: Linux 2.6.20.7 - Hard Disk rumbling?
Cc: linux-kernel@vger.kernel.org, "Greg KH" <gregkh@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, stable@kernel.org
In-Reply-To: <462B5D28.2000901@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8355959a0704210658j3b54a8cfl8a8a73661cd50c9d@mail.gmail.com>
	 <462B5D28.2000901@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> On 4/22/07, Mark Lord <lkml@rtr.ca> wrote:
>
> Opcode 0xb0 is "WIN_SMART".
> Error 0x04 is "command aborted/rejected/unsupported".
>
> Something on your system is issuing S.M.A.R.T. commands from userspace
> to the drive, and the drive either (1) doesn't support S.M.A.R.T.,
> or (2) currently does not have S.M.A.R.T. enabled (smartctl -s on /dev/hda).
>
> The "smartmontools" package is what normally issues these commands.
>

Yep, you are right. I did disable the smartd service. I am used to
SMARTing always (always work with high-end disks.). Now no issues,
thanks.

~Akula2
