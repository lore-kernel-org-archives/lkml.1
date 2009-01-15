Return-Path: <linux-kernel-owner+w=401wt.eu-S932694AbZAOVzP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbZAOVzP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 16:55:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763782AbZAOVyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 16:54:49 -0500
Received: from relay2.sgi.com ([192.48.179.30]:48296 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933178AbZAOVyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 16:54:47 -0500
Message-ID: <496FB0A5.6050004@sgi.com>
Date: Thu, 15 Jan 2009 13:54:45 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: Dieter Ries <clip2@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu>	 <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu>	 <496A3F62.8090902@gmx.de> <496F9604.8020101@sgi.com>	 <496FA4B6.3000607@gmx.de> <8db1092f0901151348l47ffcec7m638180ca2cdbe4ce@mail.gmail.com>
In-Reply-To: <8db1092f0901151348l47ffcec7m638180ca2cdbe4ce@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej Rutecki wrote:
> 2009/1/15 Dieter Ries <clip2@gmx.de>:
>> Mike Travis schrieb:
>>> Hi Dieter and Maciej,
> 
>>> Can you try the attached patches on your system?  It boots on my system fine
>>> now, but wasn't there a problem with resume as well?  (My test systems are
>>> remote so suspending/resuming over the network is iffy.)
>> I just tested it. The kernel does boot up, suspending to ram works
>> perfectly, hibernating did also work, but I found an inconsistent lock
>> state in dmesg afterwards. System is still fully functional
>>
> 
> Suspend to disk works OK (unlike latest 2.6.29-rc1-git5). But suspend
> to ram still doesn't work: resume immediately and hangs.
> 
> 

And it works ok without my patch?  Drats!  ;-)

I'll see if I can't figure out how to debug it here.

Thanks!
Mike
