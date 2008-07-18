Return-Path: <linux-kernel-owner+w=401wt.eu-S1757854AbYGRSQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757854AbYGRSQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 14:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbYGRSQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 14:16:40 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:52188 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbYGRSQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 14:16:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=KZ4CSXw6R0N2UX1eyQ6A70/W4VjTKf2r5xkG2pLEG7IhDkGDrysvOq9DjfEgZeveGj
         NgUliVtuTEuTCUvVn3i15NHJk2TAEg6XjCQStxMKKi4fz+AqNCrd0G5TrIBr7mE7RFaj
         nQ58bfNJJp0OEexrdbqyE7fgslmTfIzsmYCQ4=
Message-ID: <e9c3a7c20807181116s49982f98p8d56a6e5e8264e6e@mail.gmail.com>
Date: Fri, 18 Jul 2008 11:16:38 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Brice Goglin" <Brice.Goglin@inria.fr>
Subject: Re: [PATCH 1/2] I/OAT: Add watchdog/reset functionality to ioatdma driver
Cc: "Maciej Sosnowski" <maciej.sosnowski@intel.com>, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, net-dev@vger.kernel.org
In-Reply-To: <487B6004.6090801@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080714132215.26830.90819.stgit@linux.site>
	 <20080714132349.26830.22215.stgit@linux.site>
	 <487B6004.6090801@inria.fr>
X-Google-Sender-Auth: 36e810bf591a39ee
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 7:17 AM, Brice Goglin <Brice.Goglin@inria.fr> wrote:
> Maciej Sosnowski wrote:
>> Due to occasional DMA channel hangs observed for I/OAT versions 1.2 and 2.0
>> a watchdog has been introduced to check every 2 seconds
>> if all channels progress normally.
>> If stuck channel is detected, driver resets it.
>> The reset is done in two parts. The second part is scheduled
>> by the first one to reinitialize the channel after the restart.
>>
>
> Is all this transparent to the caller? Are you reposting all copies to
> the hardware after the reset? Or are we going to get some DMA_ERROR
> return values ?
>
>> Sleep time in self_test has been increased to 10ms
>> since in some cases 1ms appeared not to be enough
>
> Thanks Maciej, this helps a lot here.
>

Can I interpret this as a "Tested-by" for the watchdog and/or the self_test fix?

> Brice

Thanks,
Dan
