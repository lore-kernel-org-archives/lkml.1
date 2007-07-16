Return-Path: <linux-kernel-owner+w=401wt.eu-S1764607AbXGPPFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764607AbXGPPFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbXGPPEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:04:48 -0400
Received: from s2.ukfsn.org ([217.158.120.143]:56380 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762468AbXGPPEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:04:47 -0400
Message-ID: <469B8909.8030001@dgreaves.com>
Date: Mon, 16 Jul 2007 16:04:41 +0100
From: David Greaves <david@dgreaves.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: LinuxKernel@jamesplace.net
Cc: linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: Problem recovering a failed RIAD5 array with 4-drives. --RESOLVED
References: <200707120849.16068.LinuxKernel@jamesplace.net> <200707121810.57648.LinuxKernel@jamesplace.net> <18070.46997.541325.761868@notabene.brown> <200707121949.08662.LinuxKernel@jamesplace.net>
In-Reply-To: <200707121949.08662.LinuxKernel@jamesplace.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James wrote:
>>> I don't know the original order of the array before all the problems 
> started. 
>>> Is there a way to determine the original order? 
>> No, unless you have some old kernel logs of the last time it assembled
>> the array properly.
>> The one thing that "--create" does destroy is the information about
>> any previous array that the drives were a part of.
>>
>>> The order that --detail is showing now is the order that appeared after 
>>> issuing the command is it is in the email. (ie: a b c d)
>> Odd.  I cannot reproduce it.
>> I suggest you try different arrangements (of the 3 good drives and the
>> word 'missing') until you find one that 'fsck -n' likes.
>>
>> NeilBrown
>>
>>
> 
> I don't understand how the order of --detail was different than the command 
> line on my system, however....
> 
> YOU ARE A LIFE SAVER!!!
> 
> After going through 21 combinations, beginning to lose all hope and plummeting 
> into eternal despair, combo 22 worked. The array is up and working. All the 
> data (1.3Tb) is there and I'm probably the happiest character on the mail 
> list today. 
> 
> Thanks a bunch for your help.

Funnily enough someone else was having a similar problem on the linux-raid list 
at the same time

Here's a script that may be useful to others in this predicament - a hell of a 
lot quicker than doing it by hand...

The 'is the filesystem safe' test probably wants improving from a read-only mount...

http://linux-raid.osdl.org/index.php/RAID_Recovery
http://linux-raid.osdl.org/index.php/Permute_array.pl

David
