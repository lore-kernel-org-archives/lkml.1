Return-Path: <linux-kernel-owner+w=401wt.eu-S932715AbXCUQgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbXCUQgF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 12:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932963AbXCUQgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 12:36:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:6399 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932715AbXCUQgC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 12:36:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=s3fKaT4qxdTMsIa0SyOfjHcEhq2eN6er1UiuzSLpuwNU7R2Z0Pomjb9HUgae5iLJQbMCGgO2X9+s3zW9tRcjhaOoHE2E6qy8vzy3E4LFu3Ffn9gHSmPdv0abe2GU6U3hDb5xHKtPaXH/fCW5g8FK2IMKSRgykE2eDo6EgdQsAYw=
Message-ID: <46015EE8.7000001@gmail.com>
Date: Thu, 22 Mar 2007 01:35:52 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Christian <christiand59@web.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG 2.6.21-rc3-git9] SATA NCQ failure with Samsum HD401LJ
References: <fa.wBi/iM3CKSfrll7UnPHTbU0scEQ@ifi.uio.no> <200703190808.00746.christiand59@web.de> <45FE3E23.1010705@gmail.com> <200703211534.30943.christiand59@web.de>
In-Reply-To: <200703211534.30943.christiand59@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christian wrote:
> I've tested multiple kernels (including -mm series) in the range of 2.6.19.7
> (before sata_nv adma support went in) up to 2.6.20-rc4.
> Every NCQ enabled kernel I've tested showed ata errors in dmesg. So I came to 
> the conclusion that my system was faulty. I ran memtest86+ for a long time, 
> but no errors were found. After some fiddling with my HW I discovered that 
> the nforce chipset fan induced some kind of electro magnetic interference to 
> the southbridge, which could clearly be heard as a low frequency noise if I 
> plugged in my speakers to the onboard sound. After replacing the fan, my 
> system is stable again. Now running 2.6.21-rc3-mm2+rsdlv31 without errors. 
> Really strange problem he ;-)

Man, that's the strangest way to solve ATA command failures I've ever 
heard of.  Kudos to you for finding it out.  :-)

-- 
tejun
