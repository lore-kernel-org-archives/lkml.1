Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXDCTRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXDCTRk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbXDCTRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:17:40 -0400
Received: from ms-smtp-02.texas.rr.com ([24.93.47.41]:57890 "EHLO
	ms-smtp-02.texas.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXDCTRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:17:39 -0400
Message-ID: <4612A867.6050609@austin.rr.com>
Date: Tue, 03 Apr 2007 14:17:59 -0500
From: Steve French <smfrench@austin.rr.com>
User-Agent: Mozilla Thunderbird 1.0 (Windows/20041206)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-cifs-client@lists.samba.org
Subject: Re: cifs and kthread_run / kernel_thread
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Wilhelm Meier wrote:

>>m Montag, 2. April 2007 schrieb Wilhelm Meier:
>>  
>>
>  
>
>>>>>>It seems to me that I rewrote cifs_demultiplex_thread to use kthread_run
>>>>>>in DFS patch.
>>>>>>      
>>>>>>
>>>      
>>>
>>>>o.k., I found the patch on the list. Will do some testing with it.
>>>>    
>>>>
>>    
>>
>>
>>o.k., the patch seems to be fine for linux-vserver. cifs-mounting inside the 
>>guest is now possible.
>>
>>Do you see any possiblility to include this part of Igors work (not the whole 
>>DFS thing) to the mainline? It fixes the use of the deprecated api.
>
Now merged into cifs-2.6 git tree.  Thanks to Q and Wilhelm
