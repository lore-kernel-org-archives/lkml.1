Return-Path: <linux-kernel-owner+w=401wt.eu-S934242AbZJIUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934242AbZJIUzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 16:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934202AbZJIUzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 16:55:54 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:13097 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934197AbZJIUzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 16:55:53 -0400
Date: Fri, 09 Oct 2009 16:55:12 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH 0/6] ACPI: dock: code hygiene
In-reply-to: <20091007220509.15597.65501.stgit@bob.kio>
Message-id: <alpine.LFD.2.00.0910091654540.3912@localhost.localdomain>
References: <20091007220509.15597.65501.stgit@bob.kio>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

series applied to acpi-test

thanks,
Len Brown, Intel Open Source Technology Center

On Wed, 7 Oct 2009, Alex Chiang wrote:

> While poking around in the dock driver debugging the NULL ptr that
> Rafael fixed, I found the driver a little hard to read.
> 
> Here is a modest attempt to clean it up a little, and is intended as
> 2.6.33 material.
> 
> Compile-tested only. I have access to an HP nc6220 and nc6230, but neither
> of them seem to provide the _DCK method, which is needed for the dock
> driver.
> 
> Thanks.
> 
> /ac
> 
> ---
> 
> Alex Chiang (6):
>       ACPI: dock: clean up error handling paths in dock_add()
>       ACPI: dock: rename local variable 'dock_station' in dock_add()
>       ACPI: dock: clean up one more error path in dock_add()
>       ACPI: dock: add struct dock_station * directly to platform device data
>       ACPI: dock: combine add|alloc_dock_dependent_device
>       ACPI: dock: minor whitespace and style cleanups
> 
> 
>  drivers/acpi/dock.c |  259 ++++++++++++++++++++-------------------------------
>  1 files changed, 104 insertions(+), 155 deletions(-)
> 
