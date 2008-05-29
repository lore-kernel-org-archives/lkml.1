Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYE2Qkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYE2Qkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 12:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbYE2Qka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 12:40:30 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:19112 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbYE2Qk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 12:40:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=hG7r3BSKJ+zpFDLt1QwUZK8wQVWXV+txxfvhGOBqXfJbdmOTX6cXMjUpimiHQoCnZJ5F4tO0d8mjkeJux1nq2y574KQZgPBn0UskO/ZGVs34jmVtOmsIXiLrQGFqmLMu09ibNc4YlsXw8PXLCFbcb0Cm1HZmBU5Jb7FK82DmStA=
Message-ID: <483EDC73.8030602@gmail.com>
Date: Fri, 30 May 2008 01:40:19 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>, Tejun Heo <htejun@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, linux-acpi@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] libata: Handle bay devices in dock stations
References: <20080528143857.GB5585@homac.suse.de> <20080529132253.GA22309@srcf.ucam.org> <483EB33D.6010101@gmail.com> <20080529140213.GA23373@srcf.ucam.org> <20080529141421.GC9268@homac.suse.de> <20080529143541.GA24013@srcf.ucam.org> <483EBFC5.7020406@gmail.com> <20080529144934.GA24382@srcf.ucam.org> <20080529163201.GA4520@homac>
In-Reply-To: <20080529163201.GA4520@homac>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Holger Macht wrote:
> On Thu 29. May - 15:49:34, Matthew Garrett wrote:
>> Got it. It works if I lose the ata_port_freeze() from 
>> ata_acpi_detach_device. 
> 
> Tejun, any idea? This is in for quite some time now. Maybe there's some
> involved...

Does changing it to ata_port_schedule_eh() make any difference?

-- 
tejun
