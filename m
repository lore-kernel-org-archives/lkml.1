Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbXEDN2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbXEDN2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 09:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbXEDN2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 09:28:09 -0400
Received: from smtpout.mac.com ([17.250.248.177]:59580 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbXEDN2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 09:28:08 -0400
In-Reply-To: <463AE623.60501@dgreaves.com>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <1177654110.4737.91.camel@nigel.suspend2.net> <Pine.LNX.4.64.0704270910190.18521@sbz-30.cs.Helsinki.FI> <200704272324.43359.rjw@sisk.pl> <alpine.LFD.0.98.0704271442160.9964@woody.linux-foundation.org> <1177711666.4737.176.camel@nigel.suspend2.net> <35EFC5BA-D16B-41BE-A641-AEA8CCC9E0BE@mac.com> <20070503151047.GB3866@ucw.cz> <E92E80B1-2D3F-4942-A17B-AED903F535C6@mac.com> <463AE623.60501@dgreaves.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <58479992-BA7D-4CE6-B03A-A1D6B7A7CF4F@mac.com>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Back to the future.
Date: Fri, 4 May 2007 09:27:20 -0400
To: David Greaves <david@dgreaves.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On May 04, 2007, at 03:52:03, David Greaves wrote:
> Kyle Moffett wrote:
>> On May 03, 2007, at 11:10:47, Pavel Machek wrote:
>>> What happens if you try to boot and filesystems are frozen from  
>>> previous run?
>>
>> If you're just doing a fresh boot then the filesystem is already  
>> clean due to the dm freeze and so it mounts up normally.  All you  
>> need to do then is have a little startup script which purges the  
>> saved image before you fsck or remount things read-write since  
>> either case means the image is no longer safe to resume.
>
> Wouldn't it be better if freeze wrote a freeze-ID to the fs and  
> returned it? This would naturally be kept in the image and a UUID  
> mismatch would be detectable - seems safer and more flexible than  
> 'a script'.
>
> "This isn't the freeze you're looking for, move along"

Possibly, but I was referring to the _current_ behavior of the device- 
mapper freezing.  While perhaps not ideal, it's currently very easily  
usable.

Cheers,
Kyle Moffett

