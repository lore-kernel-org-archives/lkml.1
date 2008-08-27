Return-Path: <linux-kernel-owner+w=401wt.eu-S1756660AbYH0X50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbYH0X50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbYH0X5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:57:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60177 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYH0X5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:57:16 -0400
Message-ID: <48B5E9D7.6060306@pobox.com>
Date: Wed, 27 Aug 2008 19:57:11 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Heasley, Seth" <seth.heasley@intel.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "htejun@gmail.com" <htejun@gmail.com>
Subject: Re: [PATCH 2.6.26.7-rc4] ata_piix: IDE Mode SATA patch for Intel
 Ibex Peak DeviceIDs
References: <200808271640.06762.seth.heasley@intel.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF177A1450@orsmsx501.amr.corp.intel.com>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF177A1450@orsmsx501.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heasley, Seth wrote:
>> -----Original Message-----
>> From: Heasley, Seth
>> Sent: Wednesday, August 27, 2008 4:40 PM
>> To: jgarzik@pobox.com; linux-ide@vger.kernel.org; linux-
>> kernel@vger.kernel.org; htejun@gmail.com
>> Cc: Heasley, Seth
>> Subject: [PATCH 2.6.26.7-rc4] ata_piix: IDE Mode SATA patch for Intel Ibex
>> Peak DeviceIDs
>>
>> This patch updates the Intel Ibex Peak (PCH) IDE mode SATA Controller
>> DeviceIDs.
>>
>> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
>>
>> --- linux-2.6/drivers/ata/ata_piix.c.orig       2008-08-27
>> 11:32:28.000000000 -0700
>> +++ linux-2.6/drivers/ata/ata_piix.c    2008-08-27 11:47:59.000000000 -0700
>> @@ -278,12 +278,15 @@
>>        /* SATA Controller IDE (PCH) */
>>        { 0x8086, 0x3b20, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
>>        /* SATA Controller IDE (PCH) */
>> +       { 0x8086, 0x3b21, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>> +       /* SATA Controller IDE (PCH) */
>>        { 0x8086, 0x3b26, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>>        /* SATA Controller IDE (PCH) */
>> +       { 0x8086, 0x3b28, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
>> +       /* SATA Controller IDE (PCH) */
>>        { 0x8086, 0x3b2d, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>>        /* SATA Controller IDE (PCH) */
>>        { 0x8086, 0x3b2e, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata },
>> -
>>        { }     /* terminate list */
>> };
> 
> Typo in the subject line.  Should read 2.6.27-rc4.  This was built against http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6

A process note...

If you are building against torvalds/linux-2.6.git -- a good thing -- 
then it is helpful to include the top-most commit id in your message [if 
you feel it is relevant information].

For patches, meta-information like commit ids or special instructions to 
the maintainer can be included following a "---" separator (on a line by 
itself).

As an example, see this patch from Tejun, which includes a diffstat(1) 
output and note about MAXTOR in the meta-information area of the patch:

	http://marc.info/?l=linux-ide&m=118835646130927&w=2

Our tools are specially programmed to exclude the meta-information from 
the text copied into the permanent kernel linux-2.6.git changelog.

	Jeff



