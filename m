Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0BARr3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 12:47:29 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:61445 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab0BARr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 12:47:27 -0500
Date: Mon, 1 Feb 2010 12:45:57 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Alex Chiang <achiang@hp.com>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] set dock_station->flags to zero during dock_add
Message-ID: <20100201174557.GB3240@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Alex Chiang <achiang@hp.com>, lenb@kernel.org,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@kernel.org
References: <20100201163043.GA3240@think>
 <20100201173518.GA28002@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201173518.GA28002@ldl.fc.hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B671360.0191:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 10:35:18AM -0700, Alex Chiang wrote:
> Hi Chris,
> 
> Thanks for catching this. Seems better to just memset the stack
> variable before we kmemdup it in platform_deivce_register_data().
> 
> How about this instead?

[ memset instead of explicitly setting flags to zero ]

I didn't do the memset because lower down we init every other field, but
zeros are zeros really.

Looking at platform_device_register_data, you could even make ds
static...now that is sure to break in small and subtle ways later on ;)

-chris
