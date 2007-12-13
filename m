Return-Path: <linux-kernel-owner+w=401wt.eu-S932076AbXLMSb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbXLMSb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 13:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbXLMSbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 13:31:49 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbXLMSbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 13:31:48 -0500
Message-ID: <47617A11.80502@redhat.com>
Date: Thu, 13 Dec 2007 19:29:37 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070105)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [Patch 7/8] Enhanced partition statistics: procfs
References: <47615B3C.6030404@redhat.com>	<20071213090756.73de4e3e.randy.dunlap@oracle.com>	<47616DAD.5020305@redhat.com> <20071213094744.eaa0b232.randy.dunlap@oracle.com>
In-Reply-To: <20071213094744.eaa0b232.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 13 Dec 2007 18:36:45 +0100 Jerome Marchand wrote:
> 
>> Randy Dunlap wrote:
>>> The format of the /proc file is not changed except to add data
>>> at the end of each line.  Is that correct?
>>>
>> No. The line concerning partitions will display different data. The new format match the current format
>> concerning disks.
>>
>> Current partition format:
>> major minor name reads_issued sectors_read writes_issued sectors_written
>>
>> New partition format (current disk format):
>> major minor name reads_issued reads_merged sector_read ms_reading writes_completed writes_merged sectors_written ms_writing I/Os_running ms_I/O weighted_ms_I/O
> 
> 
> I would have expected the /proc file contents to represent a user
> interface that we shouldn't change, other than by adding to the end
> of each line.
> 

I could eventually keep the old data and add the new ones at the end
of the line, but it will leads to a less coherent interface. Moreover
all the users of /proc/diskstats I know about use the number of field
to make the distinction between current disk and partitions
format. They all will be confused if we add new fields.

Jérôme

