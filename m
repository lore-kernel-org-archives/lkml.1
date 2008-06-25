Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYFYPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYFYPDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 11:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYFYPDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 11:03:09 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:36243 "EHLO
	ns1.utah-nac.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751321AbYFYPDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 11:03:08 -0400
Message-ID: <2740.69.2.248.210.1214405604.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1861.69.2.248.210.1214405540.squirrel@webmail.wolfmountaingroup.com>
References: <2778.69.2.248.210.1214248946.squirrel@webmail.wolfmountaingroup.com>  
     <48614755.5080001@zytor.com>
    <1861.69.2.248.210.1214405540.squirrel@webmail.wolfmountaingroup.com>
Date: Wed, 25 Jun 2008 08:53:24 -0600 (MDT)
Subject: Re: Forensic File System GUID Linux/Windows
From: jmerkey@wolfmountaingroup.com
To: jmerkey@wolfmountaingroup.com
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> jmerkey@wolfmountaingroup.com wrote:
>>> The following GUID is being used in the Wolf Mountain Group, Inc.
>>> Forensic
>>> File System (FFS) for GPT intel EFI partitions.  Since there is no
>>> central
>>> registry for EFI GUID's it is posted here for referece for folks who
>>> may
>>> run accross it on Windows Vista, 2003, and 2008 systems running FFS on
>>> Windows that may be using dual boot with Linux or vmware:
>>>
>>> #define PARTITION_FFS_GUID \
>>>     EFI_GUID( 0xBEEFCAFE, 0xFEED, 0x0000, \
>>>               0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01)
>>>
>>
>> You would have vastly less probability of accidental collision if you
>> generated a proper random GUID, for example:
>>
>> : tazenda 118 ; uuidgen -r
>> 33ae8a9c-441e-4d97-93a3-8561388ce905
>>
>> 	-hpa
>
Thanks.  Good advice.  What we really need is someone to maintain a
central registry for UUID generation for EFI and GPT based ID's.   Since
drives are getting bigger and bigger, GPT is probably going to be the
standard 5 years from now, so sooner is better than later.  I will
regenerate a new UUID using these tools and update the software.

Thanks for the help.

:-)

Jeff
>
>
>


