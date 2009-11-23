Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbZKWOlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbZKWOlH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:41:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754219AbZKWOlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:41:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:15122 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbZKWOlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:41:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ao089ngVOP3EhgkWjtaX3r1RuzKpTf1CKUF4Yt5KpnxNYbxvjTFbMEGK0oixAjop9x
         wHHcdoeDHFQQp+ZqQE2DQLUi6oKUTuN+J/buwkB8TKpeUM78gxXrnvzAAAp7DkqKt8L6
         NeL49J9rz+XhMYWz7VpTkVKzW1ZQ+CI9G1llg=
Date: Mon, 23 Nov 2009 22:41:52 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: "Helight.Xu" <helight.xu@gmail.com>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: =?utf-8?B?5aaC5L2V6YCa6L+HZmTmib7liLA=?=
	=?utf-8?B?5omT5byA5paH5Lu255qE6Lev5b6E5Y+K5ZCN56ew?=
Message-ID: <20091123144152.GC2412@hack>
References: <4B06384C.2080703@gmail.com> <20091122163700.GC3476@hack> <4B09DF29.8020003@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B09DF29.8020003@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 09:02:33AM +0800, Helight.Xu wrote:
> Américo Wang wrote:
>> On Fri, Nov 20, 2009 at 02:33:48PM +0800, Helight.Xu wrote:
>>   
>>> 在用户程序中打开文件进行编辑，那在内核中如何能通过open后的fd
>>> 来找到相应打开文件的路径及其名字呢？
>>>
>>>     
>>
>> 问题是你为什么要在内核中做呢？在用户空间完全可以完成：
>>
>>  % readlink /proc/<PID>/fd/X
>>   
> 我是想在内核中实现一些功能，所以现在内核中找到文件的路径及其名称，


能在用户层完成的就不要跑到内核里去做，完全没必要。

而且，你在处理这个问题时还要考虑pipe和socket这些特殊的文件，
它们对应的fd可是没有file的。

> 现在只  
> 能找到文件名，还在找路径。。。

你可以看看proc文件中对fd/X的处理，或许能帮上忙。


-- 
Live like a child, think like the god.
 
