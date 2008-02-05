Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578AbYBEGjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578AbYBEGjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 01:39:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751136AbYBEGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 01:39:38 -0500
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:58994 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbYBEGji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 01:39:38 -0500
Message-ID: <47A804A2.5020208@in.ibm.com>
Date: Tue, 05 Feb 2008 12:09:30 +0530
From: "Sachin P. Sant" <sachinp@in.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071129)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, bwalle@suse.de
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [mm] Crashkernel memory reservation fails with 2.6.24-rc8-mm1
References: <47A7391F.2020408@in.ibm.com> <20080204183810.GE16021@redhat.com> <20080204193524.GA11104@suse.de> <47A7F53C.8090606@in.ibm.com>
In-Reply-To: <47A7F53C.8090606@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sachin P. Sant wrote:
> Bernhard Walle wrote:
>> * Vivek Goyal <vgoyal@redhat.com> [2008-02-04 19:38]:  
>>> Bernahard, any idea who is the competitor here?     
>> Hm ..., can you boot the kernel without crashkernel= and provide the
>> /proc/iomem?   
> Attached is the /proc/iomem output with and without crashkernel
> parameter.
>
> Adding debug gives this extra information.
>
> hm, page 02a9d000 reserved twice.
> crashkernel reservation failed - memory is in use
>
> Will try to add more debug statements.
Hm . no problem with 2.6.24-mm1.

early res: 4 [9dc00-a0bff] EBDA
early res: 5 [8000-11fff] PGTABLE
Reserving 128MB of memory at 32MB for crashkernel (System RAM: 9088MB)
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0

# cat /proc/iomem
......
 008b8000-0099dc8b : Kernel bss
  02000000-09ffffff : Crash kernel
c7fcae00-c7fcf7ff : ACPI Tables
.....

Thanks
-Sachin

