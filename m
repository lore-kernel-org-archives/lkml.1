Return-Path: <linux-kernel-owner+w=401wt.eu-S965955AbXC2FI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965955AbXC2FI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 01:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965957AbXC2FI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 01:08:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:49812 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965955AbXC2FIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 01:08:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=ES7Ycg+J8Hc9XjNhhmV+FQHgtSzhmfcmPIOq5oC+sLvkPLsdy3GuJP0pCrcAhChCaoH5nD7KeUTG+ucw6oieXMSLZcO8dYqQ+L/Bj+FToyY9pfhAxC9MDSVp/kSJ8MYmczAHO3VVdZOD0jfo+xsCDUftV6zfoJ9ArqjfwmfFwt0=
Message-ID: <86802c440703282208m1f79c682q876e4d08d9216cd2@mail.gmail.com>
Date: Wed, 28 Mar 2007 22:08:23 -0700
From: "Yinghai Lu" <yinghai.lu@amd.com>
To: "Jeff Garzik" <jgarzik@pobox.com>
Subject: Re: [2.6 patch] the scheduled eepro100 removal
Cc: "Kok, Auke" <auke-jan.h.kok@intel.com>, "Bill Davidsen" <davidsen@tmr.com>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, saw@saw.sw.com.sg,
       "Jesse Brandeburg" <jesse.brandeburg@intel.com>
In-Reply-To: <460AEF65.8070908@pobox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070325145810.GI16477@stusta.de> <460AE997.90509@tmr.com>
	 <460AEB85.1020101@intel.com> <460AEF65.8070908@pobox.com>
X-Google-Sender-Auth: e0c7769cfdc80c65
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/28/07, Jeff Garzik <jgarzik@pobox.com> wrote:
> Kok, Auke wrote:
> Sounds sane to me.  My overall opinion on eepro100 removal is that we're
> not there yet.  Rare problem cases remain where e100 fails but eepro100
> works, and it's older drivers so its low priority for everybody.
>
> Needs to happen, though...
>

It seems that several Tyan Opteron base system that were using IPMI
add on card.  the IPMI card share intel 100Mhz nic onboard. you need
to use eepro100 instead of e100 otherwise the e100 will shutdown OOB
(out of Band) connection for IPMI when shut down the OS.

YH
