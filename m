Return-Path: <linux-kernel-owner+w=401wt.eu-S1763159AbYEBIUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763159AbYEBIUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 04:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753675AbYEBIUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 04:20:40 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:52490 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYEBIUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 04:20:37 -0400
Message-ID: <481ACEC4.2040205@krogh.cc>
Date: Fri, 02 May 2008 10:20:20 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Many open/close on same files yeilds "No such file or directory".
References: <4819E316.7000607@krogh.cc> <20080501223938.921f7cd2.akpm@linux-foundation.org>
In-Reply-To: <20080501223938.921f7cd2.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> I cannot reproduce it on other disks attached to the same server or on
>> other servers attached to similar disksystems.
> 
> hmm.
> 
> I guess it would be interesting to remount that filesystem with `noatime'
> to eliminate the last bit of I/O and block-=realted code.

It is allready mounted noatime:
/dev/mapper/fx1200_vg-fx1200_lv on /z/fx1200 type ext3 (rw,noatime)

>> I'm about to mkfs.ext3 the volume and spool it back in from the backup,
>> but somehow I'm not convinced that it will solve the problem at all.
>> It may just be a hardware problem, but dmesg doesnt tell anything.
>>
>> We actually got the problem from a perl-script, but this seems to be the
>> minimal program that reproduces the problem.
> 
> I'd suspect that after 1e8 loops your CPU got too hot and started to
> misbehave.

Hardware is an Sun Fire X4600 (8xdual-core AMD64 processors). The
problem seem to be tied to this filesystem. (I cannot havent been able
to reproduce it on the /-mounted disk of the same system. So if a cpu
problem.. then it shouldn't be tied to a specific filesystem?

This is the only activity on the system .. so a load of 1 / 16cpus.

The system are generally rock-solid.

Jesper
-- 
Jesper
