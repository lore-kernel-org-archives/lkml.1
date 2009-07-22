Return-Path: <linux-kernel-owner+w=401wt.eu-S1751723AbZGVJTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbZGVJTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZGVJTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:19:42 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47325 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbZGVJTl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:19:41 -0400
Message-ID: <4A66DA2E.90601@redhat.com>
Date: Wed, 22 Jul 2009 17:21:50 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Miklos Szeredi <mszeredi@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
Subject: Re: [Patch] pipe: use file_update_time() when hold i_mutex
References: <20090706053745.6338.50777.sendpatchset@localhost.localdomain>	 <20090720141150.e9d081ca.akpm@linux-foundation.org>	 <4A65934B.9050904@redhat.com> <1248174580.28516.595.camel@tucsk>
In-Reply-To: <1248174580.28516.595.camel@tucsk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> On Tue, 2009-07-21 at 18:07 +0800, Amerigo Wang wrote:
>   
>> Andrew Morton wrote:
>>     
>>> On Mon, 6 Jul 2009 01:35:30 -0400
>>> Amerigo Wang <amwang@redhat.com> wrote:
>>>
>>>   
>>>       
>>>> file_update_time() should be called with i_mutex held,
>>>> move it before mutex_unlock().
>>>>
>>>>     
>>>>         
>>> Why do you believe that file_update_time() needs i_mutex?
>>>   
>>>       
>> file_update_time() modifies inode, no? :)
>>     
>
> So does touch_atime(), yet neither needs i_mutex.
>   
Yes?

Then how the inode is protected when file_update_time() modifies
it?

Thanks.

