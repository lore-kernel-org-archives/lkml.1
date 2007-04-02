Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbXDBPMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbXDBPMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbXDBPMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:12:44 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58595 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165AbXDBPMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:12:44 -0400
Message-ID: <46111D66.8060208@us.ibm.com>
Date: Mon, 02 Apr 2007 10:12:38 -0500
From: "Steve French (smfltc)" <smfltc@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Q (Igor Mammedov)" <qwerty0987654321@mail.ru>
CC: linux-cifs-client@lists.samba.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-cifs-client] Re: cifs and kthread_run / kernel_thread
References: <20070331120030.BE6A916387F@lists.samba.org> <46100407.30403@us.ibm.com> <4610B80F.9020102@mail.ru>
In-Reply-To: <4610B80F.9020102@mail.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Q (Igor Mammedov) wrote:

> Steve French (smfltc) wrote:
>
>> No - IIRC the original patch (for the switch of cifs from 
>> kernel_thread to kthread) had a
>> minor implementation problem in handling the cifs_demultiplex thread, 
>> so this one small
>> area was left with the old style.
>>
>>> iii) Is it difficult to switch to the new interface?
>>>  
>>>
>> No, I don't think so, but I have not investigated it.  We would be happy
>> to review and test a patch for this though.
>>
>>> ***************************
>>
>
> It seems to me that I rewrote cifs_demultiplex_thread to use 
> kthread_run in DFS patch.
>
Yes - Q's  patch has the final change to kthread (as part of a larger 
DFS change).  The original
patch which switched to kthread was done long before this.

I have not broken all the large dfs patch into small pieces but will 
look to see if just this part
can be done easily
