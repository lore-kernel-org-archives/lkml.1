Return-Path: <linux-kernel-owner+w=401wt.eu-S932332AbXB1Nep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332AbXB1Nep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 08:34:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932334AbXB1Neo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 08:34:44 -0500
Received: from mail.tmr.com ([64.65.253.246]:53653 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932332AbXB1Neo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 08:34:44 -0500
Message-ID: <45E5853A.3060901@tmr.com>
Date: Wed, 28 Feb 2007 08:35:54 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Florin Iucha <florin@iucha.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc1: CIFS cheers, NFS4 jeers
References: <20070226064500.GZ29073@iucha.net> <45E4EAA7.2090007@tmr.com> <20070228040345.GL29073@iucha.net>
In-Reply-To: <20070228040345.GL29073@iucha.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florin Iucha wrote:
> On Tue, Feb 27, 2007 at 09:36:23PM -0500, Bill Davidsen wrote:
>   
>> Florin Iucha wrote:
>>     
>>> Hello, it's me and my 70 GB of photos again.
>>>
>>> I have tested both CIFS and NFSv4 clients in kernel 2.6.20-rc1 . CIFS
>>> passed with flying colors and NFSv4 stalled after 7 GB.
>>>       
>
>   
>> Neil has been diddling NFS, I did some light testing with 2.6.20-git14 
>> with 190GB of mp3 and mpg files (library of congress folk music) without 
>> hangs. Just "did it work" tests, copy 20-30GB to server, do md5 on the 
>> data pulled back from the server.
>>
>> Didn't hang, performance testing later.
>>     
>
> 2.6.20-rcX used to copy all files then hang on certain operations that
> I think used the VFS.  2.6.21-rc1 stalls the NFS transfer itself after
> several GB.  The data was never corrupted.
>
> Have you tried copying _ALL_ 190 GB to the server?

No, but as noted I was doing 20-30GB, so if "several" is a small number 
I'm not seeing that behavior. I'm using a Gbit connection if that is not 
the same as your setup. I have additional testing queued for time 
available this week.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

