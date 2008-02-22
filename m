Return-Path: <linux-kernel-owner+w=401wt.eu-S1761856AbYBVQ7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761856AbYBVQ7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 11:59:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761538AbYBVQ7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 11:59:20 -0500
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59862 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761480AbYBVQ7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 11:59:18 -0500
Message-ID: <47BEFF5F.9020002@cs.wisc.edu>
Date: Fri, 22 Feb 2008 10:59:11 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: markh@compro.net
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: New 2.6.24.2 SG_IO SCSI problems
References: <47BD9588.9080803@compro.net> <47BEFD4B.9060803@cs.wisc.edu>
In-Reply-To: <47BEFD4B.9060803@cs.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Christie wrote:
> Mark Hounschell wrote:
>> I seem to have run into some sort of regression in the SG_IO interface 
>> of 2.6.24.2. I have an application that up until 2.6.24 worked fine. 
>> The 2.6.23.16 kernel works fine.
>>
>> During reads I get these kernel messages. Writes and other functions 
>> _seem_ OK. Actually basic
>> reads  are working. Its with large BC reads using an io_vec list that 
>> the problem shows up.
>>
> 
> Are you doing SG_IO to the sg device (/dev/sg*) or to the block device 
> (/dev/sdX)?

If you are doing SG_IO to the sg device, then I know of one regression 
(well not regression exactly, but I fixed a bug but the patch got 
partially overwritten by another patch and that caused a new bug). Both 
bugs are fixed in 2.6.25-rc2. Could you try that out if you are doing 
SG_IO to the sg device.
