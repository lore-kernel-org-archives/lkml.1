Return-Path: <linux-kernel-owner+w=401wt.eu-S1752268AbZKTJyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbZKTJyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 04:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZKTJyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 04:54:11 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38119 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZKTJyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 04:54:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tOw6NBtdX2WvpEcHcKW4rVHN9bvMN0h/edCAxAS0AlmyUyJIWJwHJKMa/IsUkVZeQ2
         D+sKLLexO92Ovo/6IxzN1MNd7WCp8UOlDRJOBP6TBis3M2ZZNcOtjRbWaQpe1O+TDuYS
         t0QEjR1R27U569gCnq0h4Oa+6BDIQwlTvh41g=
Message-ID: <4B06677B.9050101@gmail.com>
Date: Fri, 20 Nov 2009 17:55:07 +0800
From: "Helight.Xu" <helight.xu@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: =?UTF-8?B?5aaC5L2V6YCa6L+HZmTmib7liLDmiZPlvIDmlofku7bnmoTot68=?=
 =?UTF-8?B?5b6E5Y+K5ZCN56ew?=
References: <4B06384C.2080703@gmail.com> <7b6bb4a50911200012s67b28e58g8109b71479ef4257@mail.gmail.com>
In-Reply-To: <7b6bb4a50911200012s67b28e58g8109b71479ef4257@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng wrote:
> in fs/open.c
>    sys_open
>              | --> do_sys_open
>                           |--->  fd_install
>
> Then fd is installed into file_fdtable
>
> in fs/file_table.c
>      fget_light/fget
>             |----> fcheck_files
>
> Then kernel get files from fd.
>   
struct file is easy to get : current->files->fd_array[fd]

but I didn't find the file name!
> 2009/11/20 Helight.Xu <helight.xu@gmail.com>:
>   
>> 在用户程序中打开文件进行编辑，那在内核中如何能通过open后的fd
>> 来找到相应打开文件的路径及其名字呢？
>>
>> --
>> ---------------------------------
>> Zhenwen Xu - Open and Free
>> Home Page:      http://zhwen.org
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>     
>
>   


-- 
---------------------------------
Zhenwen Xu - Open and Free
Home Page:	http://zhwen.org

