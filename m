Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0BKXML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:12:11 -0500
Received: from mailc.microsoft.com ([131.107.115.214]:15022 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757197Ab0BKXMI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:12:08 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: Greg KH <gregkh@suse.de>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
       Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Thread-Topic: [PATCH 1/2] Staging: hv: Add proper versioning to HV drivers
Thread-Index: AQHKq2HENZ6t0wcb1kW/75fbKuFcg5HB8/2A//+AowCAAI1mgP//hFWg
Date: Thu, 11 Feb 2010 23:11:26 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56212E88403@TK5EX14MBXC118.redmond.corp.microsoft.com>
References: <8AFC7968D54FB448A30D8F38F259C56212E88287@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211213651.GA29557@suse.de>
 <8AFC7968D54FB448A30D8F38F259C56212E8831E@TK5EX14MBXC118.redmond.corp.microsoft.com>
 <20100211222705.GA30430@suse.de>
In-Reply-To: <20100211222705.GA30430@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>In short I would strongly advise against doing this, unless you are
>willing to attempt to keep this up to date, and in reality, just ignore
>the number as it means nothing.
>
>This is also especially relevant given that Linux drivers are tightly
>tied to the kernel version they are running on, as APIs change
>constantly over time.  You can not just take one version of a driver on
>one release, and drop it in another kernel version, without usually
>changing something.  That change then "invalidates" the version number
>scheme :)
>
>Does this make sense?

Absolutely, Trying to satisfy internal requests do not always line up to 
external standards in the Linux Kernel. I agree with pretty much all you
said. I think we have come up with something that we all can live with. 

>> Would you like me to re-roll the patch to remove the DATE/TIME stuff
>> And add the explanation for versioning as comments to the code?
>
>Yes, please do, and possibly drop the "minor" number, otherwise I am
>going to have fun incrementing it with every single code change I do to
>the drivers.  That would be what, version 264 or something by now?  :)

I think it should be even higher than that :)  But it was never intended to be
used by anybody other than MS devs submitting code. 

I just submitted a new patch taking into account all that you requested.

As always, thanks for your help!

thanks,

Hank.


