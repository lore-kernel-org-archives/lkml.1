Return-Path: <linux-kernel-owner+w=401wt.eu-S934644AbYBTV6a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934644AbYBTV6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:58:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933898AbYBTV6K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:58:10 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:42907 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765414AbYBTV6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:58:07 -0500
Message-ID: <47BCA229.1090406@oracle.com>
Date: Wed, 20 Feb 2008 13:56:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Marcel Holtmann <marcel@holtmann.org>
CC: lkml <linux-kernel@vger.kernel.org>, gregkh <greg@kroah.com>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] firmware: fix a few build errors
References: <20080220132100.c168fc20.randy.dunlap@oracle.com> <6196E805-23A7-47EA-813C-1FDDEA8949FC@holtmann.org>
In-Reply-To: <6196E805-23A7-47EA-813C-1FDDEA8949FC@holtmann.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcel Holtmann wrote:
> Hi Randy,
> 
>> Fix one typo (comma to semi-colon).
>> Fix sysfs externs (just use sysfs.h for prototypes).
>>
>> Documentation/firmware_class/firmware_sample_firmware_class.c:37: 
>> error: conflicting types for 'sysfs_remove_bin_file'
>> include/linux/sysfs.h:100: error: previous declaration of 
>> 'sysfs_remove_bin_file' was here
>>
>> Still has a build error:
>> ERROR: "firmware_class" 
>> [samples/firmware_class/firmware_sample_firmware_class.ko]
>> undefined!
> 
> while you are at it, can you also fix the broken coding style in it?

Greg will do that while he is fixing the <firmware_class> data build error. :)

-- 
~Randy
