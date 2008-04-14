Return-Path: <linux-kernel-owner+w=401wt.eu-S1761008AbYDNPns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761008AbYDNPns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:43:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753838AbYDNPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:43:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:22061 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYDNPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cBpvh8jv1EGHX6EW2oao0UdBC2Bkq3rHxxZqaed9yrZ8aT5YNljCic8m20uG4jICwCniiF6RZwm1BkzKbKnUHW8UxcE+J/lM/d+K2+ejdqPqAtfE8NAwZnwu7xDiKyP+k71bjtIzJouUBXAY4x5HRHSAwgQPF0H/+s4D59f/b/k=
Message-ID: <48037BA4.6070201@gmail.com>
Date: Mon, 14 Apr 2008 17:43:32 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Timur Tabi <timur@freescale.com>
CC: linuxppc-dev@ozlabs.org, Andrew Morton <akpm@linux-foundation.org>,
       York Sun <yorksun@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Driver for Freescale 8610 and 5121 DIU
References: <12053582234100-git-send-email-yorksun@freescale.com>	<12053582231281-git-send-email-yorksun@freescale.com>	<47D8572C.8090501@gmail.com>	<47FFDBFF.1030809@gmail.com>	<20080411221817.0b1eb414.akpm@linux-foundation.org>	<48035E93.6070300@freescale.com> <48035F98.1020404@gmail.com>	<48036001.10905@freescale.com> <4803620C.6020905@gmail.com>	<48036649.6000409@freescale.com> <4803690A.3080105@gmail.com> <48036F00.6080200@freescale.com>
In-Reply-To: <48036F00.6080200@freescale.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2008 04:49 PM, Timur Tabi wrote:
> Jiri Slaby wrote:
>> On 04/14/2008 04:12 PM, Timur Tabi wrote:
>>> Unfortunately, the author of the patch, York, is out this week, so I'll have to
>>> take care of this.  It'd be easier to modify rh_alloc() so that it doesn't
>>> sleep, so that's what I'm going to do.
>> Anyway, why do you need the spin lock there (and not mutex)? 
> 
> I don't know.  A spinlock just seemed obvious.  Why would I prefer a mutex?

Mainly because you can sleep inside locked mutex and because spinlock shouldn't
be used for too many lines of code (busy waiting etc.). I think ldd3 will be
more descriptive than me here :).

