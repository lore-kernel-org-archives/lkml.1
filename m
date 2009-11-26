Return-Path: <linux-kernel-owner+w=401wt.eu-S1752205AbZKZBzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205AbZKZBzg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 20:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZKZBzf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 20:55:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850AbZKZBzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 20:55:35 -0500
Message-ID: <4B0DDFDA.1030905@redhat.com>
Date: Wed, 25 Nov 2009 20:54:34 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Dan Merillat <dan.merillat@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, linux-kernel@vger.kernel.org,
       Norbert Preining <preining@logic.at>,
       Tomasz Chmielewski <mangoo@wpkg.org>,
       Sven-Haegar Koch <haegar@sdinet.de>, Dave Chinner <david@fromorbit.com>
Subject: Re: Linux 2.6.31 - very swap-happy with plenty of free RAM
References: <c0c067900911172356n2717ce9dn8a4231345903fde6@mail.gmail.com>	 <2f11576a0911190636vd21069bv2fe4f22a57b3d333@mail.gmail.com> <c0c067900911251513v48a34b18k73fb48f0e8d43c30@mail.gmail.com>
In-Reply-To: <c0c067900911251513v48a34b18k73fb48f0e8d43c30@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2009 06:13 PM, Dan Merillat wrote:
> On Thu, Nov 19, 2009 at 9:36 AM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com>  wrote:
>    
>> Hi Dan,
>>
>> Umm, very strange.
>> I made two debug patch. can you please apply it and post following
>> command output?
>>
>> % cat /proc/meminfo
>> % cat /proc/vmstat
>> % cat /proc/zoneinfo
>> # cat /proc/filecache | sort -nr -k3 |head -30
>>      
> As I said I can't give you the filecache info, but here's two  datasets
>
> The  amount of cache is due to 1.5gb of mmaped vmware guest backing files.
>
> First, 400mb ram "free" but still swapping out - usable with a few
> pauses as apps swap back in.
>
>    
Can you try out the patch from
http://lkml.org/lkml/2009/11/25/467 ?
