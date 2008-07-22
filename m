Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYGVXf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYGVXf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758114AbYGVX1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:27:06 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:33697 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757319AbYGVX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:27:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Jcu2rfxN1J5M5M3XHzzpHWwZvyoixmu+2yMz/uyEzf8d0V03sSN3wAbuzeyInX9tBS
         SgRh/jtTPqtnsgONBc1ml/9eRFxKBrob7BK6UqAKjrUN1HB6fV4FdadiutHXWkVftHft
         9sLCuXoe01KdGuhMBlneYch2qeC5foSDFCOMo=
Message-ID: <e9c3a7c20807221627r78a55c1bx2c68461602150c22@mail.gmail.com>
Date: Tue, 22 Jul 2008 16:27:02 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>
Subject: Re: [PATCH 1/2] I/OAT: Add watchdog/reset functionality to ioatdma driver
Cc: "Maciej Sosnowski" <maciej.sosnowski@intel.com>, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, net-dev@vger.kernel.org
In-Reply-To: <48811047.1030509@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714132215.26830.90819.stgit@linux.site>
	 <20080714132349.26830.22215.stgit@linux.site>
	 <487B6004.6090801@inria.fr>
	 <e9c3a7c20807181116s49982f98p8d56a6e5e8264e6e@mail.gmail.com>
	 <48811047.1030509@inria.fr>
X-Google-Sender-Auth: 0f6e9f24bbfd2ad4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 2:51 PM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> Dan Williams wrote:
>>>> Sleep time in self_test has been increased to 10ms
>>>> since in some cases 1ms appeared not to be enough
>>> Thanks Maciej, this helps a lot here.
>>>
>>
>> Can I interpret this as a "Tested-by" for the watchdog and/or the self_test fix?
>
> The sleep time increase to 10ms has been tested for a while (and helps a
> lot here).
>

On my system I can still occasionally reproduce the self-test failure
with this longer timeout.  I think we should hold off on this band-aid
patch until the root cause is found.  We can get this fix in after the
merge window closes.

> I don't know about the watchdog yet.

This one has been observed to fix the hang condition so I will include
it in my upcoming pull request.  Holler if your testing proves
otherwise.

Thanks,
Dan
