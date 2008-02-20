Return-Path: <linux-kernel-owner+w=401wt.eu-S933382AbYBTUN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933382AbYBTUN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:13:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765921AbYBTUL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:11:29 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:53822 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765793AbYBTUL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:11:26 -0500
Message-ID: <47BC893C.6060309@oracle.com>
Date: Wed, 20 Feb 2008 12:10:36 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] documentation: fix firmware_sample_firmware_class to
 build
References: <20080218162216.ee1501fd.randy.dunlap@oracle.com> <20080220064642.GA22884@kroah.com>
In-Reply-To: <20080220064642.GA22884@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Feb 18, 2008 at 04:22:16PM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix firmware_sample_firmware_class module to build without error.
>> sysfs.h already has the function prototypes and has them correctly.
>>
>> Documentation/firmware_class/firmware_sample_firmware_class.c:37: error: conflicting types for 'sysfs_remove_bin_file'
>> include/linux/sysfs.h:100: error: previous declaration of 'sysfs_remove_bin_file' was here
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  Documentation/firmware_class/firmware_sample_firmware_class.c |    3 ---
>>  1 file changed, 3 deletions(-)
> 
> Can we move this file to the samples/ directory, so the build will catch
> stuff like this?
> 
> What's the final version of this patch?

I've moved it to samples/, but it (still) has a build problem:

ERROR: "firmware_class" [samples/firmware_class/firmware_sample_firmware_class.ko] undefined!

Can you give me hint(s) about how to fix that?

-- 
~Randy
