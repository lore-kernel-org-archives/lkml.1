Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYLaPd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYLaPd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:33:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYLaPdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:33:46 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:28070 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752265AbYLaPdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:33:45 -0500
Message-ID: <495B90D5.5090903@panasas.com>
Date: Wed, 31 Dec 2008 17:33:41 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: avishay@gmail.com, jeff@garzik.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] exofs: osd Swiss army knife
References: <4947BFAA.4030208@panasas.com>	<1229439174-30492-1-git-send-email-bharrosh@panasas.com> <20081229122959.2cb48cf7.akpm@linux-foundation.org>
In-Reply-To: <20081229122959.2cb48cf7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Dec 2008 15:33:39.0623 (UTC) FILETIME=[27899B70:01C96B5D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> +int prepare_get_attr_list_add_entry(struct osd_request *req,
>> +				    uint32_t page_num,
>> +				    uint32_t attr_num,
>> +				    uint32_t attr_len)
>> +{
>> +	struct osd_attr attr = {
>> +		.page = page_num,
> 
> Kernel developers expect a field called "page" to have type `struct
> page *'.  osd_attr.page is thus designed to confuse.
> 
>> ...
>>
> 

Rant below (can be ignored):
  This single fix will cause a massive change to the open-osd
  initiator patchset, (18 patches), and resubmission .I made the mistake
  because this name originates from a file that all naming conventions
  are taken from the OSD standard text. However this is no excuse
  for using a well known Kernel construct name. I will fix it. And
  will be more careful in the future.

Thanks
Boaz
 
