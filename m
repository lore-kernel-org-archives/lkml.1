Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbYAYT1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbYAYT1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 14:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYAYT1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 14:27:34 -0500
Received: from gw.goop.org ([64.81.55.164]:39110 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbYAYT1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 14:27:34 -0500
Message-ID: <479A3823.7000009@goop.org>
Date: Fri, 25 Jan 2008 11:27:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <Yinghai.Lu@Sun.COM>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: trim ram need to check if mtrr is there v3
References: <47993F1A.5070408@goop.org> <200801241947.55223.yinghai.lu@sun.com> <4799930B.40006@goop.org> <200801250042.53074.yinghai.lu@sun.com> <20080125110935.GA20026@elte.hu> <479A30A3.7050305@goop.org> <20080125185923.GA2518@elte.hu> <479A3222.30008@goop.org> <20080125190418.GA7817@elte.hu>
In-Reply-To: <20080125190418.GA7817@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> I was referring to:
>>
>> commit 6a4544a9c8b54b82893044cb53695502cc386f00
>> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>
>> Date:   Fri Jan 25 00:15:29 2008 +0100
>>
>>    x86_32: trim memory by updating e820 v3
>>
>> but you've answered the question...
>>     
>
> yeah, i guess what i've pushed out just now is v3++. Does it work for 
> you?
>   

Yes, it does.  And for the record:

[root@qemu ~]# cat /proc/mtrr 
[root@qemu ~]# 

	J

