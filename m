Return-Path: <linux-kernel-owner+w=401wt.eu-S1753782AbYH2KFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbYH2KFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 06:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751245AbYH2KEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 06:04:51 -0400
Received: from ag-out-0708.google.com ([72.14.246.248]:19483 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYH2KEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 06:04:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=EJS4qwb7m2fIzbb74QoupuxIXO2n6EUkMTkGcCg6eVMXWPueAMIdoaloXKgoAJcYKx
         XpZ1oAW/U+0EO7P8/9EmfmSTEbQSWt9bTIxntFnDNGoO4nXP7n/Yu2USh7HrdSrFMQwH
         RaXoEciRWibDCgYeMrwwIQl3PxLKpNKQfa4NE=
Message-ID: <48B7C979.1000606@gmail.com>
Date: Fri, 29 Aug 2008 12:03:37 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       linux-ide@vger.kernel.org, Thomas Renninger <trenn@suse.de>,
       Robert Hancock <hancockr@shaw.ca>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression: SATA disk double spin-off during hibernation on hp
 nx6325
References: <200808290002.55026.rjw@sisk.pl>
In-Reply-To: <200808290002.55026.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Rafael J. Wysocki wrote:
> It appears that the "double spin-off" problem described in
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=8855
> 
> has recently started to appear during hibernation as well as during shutdown.
> It didn't appear during hibernation on my hp nx6325 with 2.6.26, so this is a
> recent regression.
> 
> I have prepared the appended patch that fixes the problem for me, based on the
>  earlier Tejun's patch at
> 
> http://bugzilla.kernel.org/attachment.cgi?id=15441&action=view
> 
> but I'm not really sure if this is an acceptable solution.  Please advise.
> 
> Thanks,
> Rafael
> 
> 
> not-yet-signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

The libata part looks fine to me but what are those SYSTEM_SUSPEND_DISK
stuff?  They don't look like belonging to this patch.

Thanks.

-- 
tejun
