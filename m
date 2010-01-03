Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543Ab0ACC6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab0ACC6b (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 21:58:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038Ab0ACC6a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 21:58:30 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:34092 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0ACC63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 21:58:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cpuxbpLDShJt5olRlX+9jC170NcqT6KGacEPTpPw40/U5IKqfdF3+PbLqHrzYKX3ph
         /tZwo8ZuvK3nESq2tJeyNDf6TFH2TjaBapjlw0IJJlhFvVEq3UnV29BSX4+Tv4QJ+IoX
         HVL3+FT49D9HVdT3FYIojdD7Aahkm6r52z5+o=
Message-ID: <4B4007D3.3090405@gmail.com>
Date: Sat, 02 Jan 2010 20:58:27 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: bugs+linux-ide@grueslayer.com
CC: linux-ide@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: pata_pdc202xx_old regression?
References: <19263.43745.540746.751448@jabber.grueslayer.com>	<4B3FB771.3070701@gmail.com> <19263.64689.654744.283071@jabber.grueslayer.com>
In-Reply-To: <19263.64689.654744.283071@jabber.grueslayer.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2010 08:10 PM, David A. Sinck wrote:
>
>
>> SMTP quoth Robert Hancock on 1/2/2010 15:15 as having spake thusly:
>>
>> On 01/02/2010 02:21 PM, David A Sinck wrote:
>>>
>>> Greetings&   Happy New Year!
>>>
>>> I believe I've come across one of two things:
>>>
>>> a) a regression in pata_pdc202xx_old
>>> b) a clueless end user wrt the list :-)
>>>
>>> The short version: running Ubuntu's Jaunty release (2.6.28-17-generic
>>> #58-Ubuntu i686) I can cleanly access the disks hanging off of an
>>> onboard Promise 20265; attempting to upgrade to Ubuntu Karmic
>>> (presumptively 2.6.31.16.29) has numerious problems reading these same
>>> drives, including:
>>>
>>>     e2label: No such file or directory while trying to open /dev/sda1
>>>     Couldn't find a valid filesystem superblock.
>>>
>>> I've documented as much as I can think of that's relevant here:
>>>
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/489685
>>>
>>> I'm willing to run tests + update the bug with further information
>>> ... if I knew what would be useful.
>>>
>>> It might even be solved upstream from the release Karmic's using?
>>
>> That dmesg output is from the working setup, correct? Can you get any
>> output from the non-working one?
>
> I've uploaded /var/log/ { kern.log | syslog | dmesg } from a running
> Karmic live cd (post release); I snapshotted the whole directory but
> limited myself to those files figuring they'd be most likely to be the
> helpful ones.
>
> Let me know what else I can do; thanks for the timely response!

Well, it looks like all the drives got detected OK. I'm not sure what 
the device-mapper errors are though, and I'm not sure why you wouldn't 
be getting any device nodes showing up for them.. CCing linux-kernel.

Jan  3 01:43:51 ubuntu kernel: [    4.978003] device-mapper: table: 
252:0: zero-length target
Jan  3 01:43:51 ubuntu kernel: [    4.978009] device-mapper: ioctl: 
error adding target to table
Jan  3 01:43:51 ubuntu kernel: [    4.996613] device-mapper: table: 
252:0: zero-length target
Jan  3 01:43:51 ubuntu kernel: [    4.996620] device-mapper: ioctl: 
error adding target to table
Jan  3 01:43:51 ubuntu kernel: [    5.372214] device-mapper: table: 
252:0: zero-length target
Jan  3 01:43:51 ubuntu kernel: [    5.372221] device-mapper: ioctl: 
error adding target to table
Jan  3 01:43:51 ubuntu kernel: [    5.680349] device-mapper: table: 
252:0: zero-length target


