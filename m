Return-Path: <linux-kernel-owner+w=401wt.eu-S1755495AbYE2DJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495AbYE2DJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 23:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbYE2DIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 23:08:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:10219 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbYE2DIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 23:08:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=KEU4IwaGCyM/hfenO/KC8Hj11Y987SkMpDLIMIpbVL+qS6KAs58eQGv5ykYBaIk7GRqmqGVpL3uNZuOi5R27UozoSTRGjDS/qDLPZ2lhxoenxu051EiX6Dd67Hn+UYFUbifMLShR+5myRAm8gMFOxIvLJsG7bGGcTGPIxta1QKE=
Message-ID: <483E1E3C.8070307@gmail.com>
Date: Thu, 29 May 2008 12:08:44 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Holger Macht <hmacht@suse.de>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       linux-acpi@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de> <20080528200227.80f708cd.akpm@linux-foundation.org>
In-Reply-To: <20080528200227.80f708cd.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +	if (ACPI_FAILURE(acpi_evaluate_object(handle, "_EJ0",
>> +					      &arg_list, NULL)))
>> +		printk(KERN_ERR "Failed to evaluate _EJ0!\n");
>> +}
> 
> It would be better if the printk were to self-identify where it is
> coming from.  If your kernel just blurts "Failed to evaluate _EJ0!"
> it's a bit of a head-scratcher.
> 
> "libata-acpi: failed to evaluate _EJ0", perhaps?

ata_port_printk() would be better.

Thanks.

-- 
tejun
