Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXDCHij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXDCHij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 03:38:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932672AbXDCHij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 03:38:39 -0400
Received: from minas.ics.muni.cz ([147.251.4.40]:49257 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932561AbXDCHi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 03:38:27 -0400
Message-ID: <46120449.7070302@gmail.com>
Date: Tue, 03 Apr 2007 09:37:45 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jirislaby@gmail.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, pavel@suse.cz
Subject: Re: 2.6.21-rc5: swsusp: Not enough free memory
References: <460B6E4B.3060004@gmail.com> <200704012123.54797.rjw@sisk.pl> <4610BDD7.5070201@gmail.com> <200704022318.28451.rjw@sisk.pl>
In-Reply-To: <200704022318.28451.rjw@sisk.pl>
X-Enigmail-Version: 0.95b
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Muni-Spam-TestIP: 147.251.48.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Tue, 03 Apr 2007 09:37:52 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki napsal(a):
> On Monday, 2 April 2007 10:24, Jiri Slaby wrote:
>> Rafael J. Wysocki napsal(a):
>>>>> On Thursday, 29 March 2007 09:44, Jiri Slaby wrote:
>>>>>> swsusp: critical section:
>>>>>> swsusp: Need to copy 131380 pages
>>>>>> swsusp: Not enough free memory
>>>>>> Error -12 suspending
>>>>>> Enabling non-boot CPUs ...
>>> As a workaround, you can try to change the initial image size so that it's
>>> smaller than a half of the RAM size.  If that works, I'd like to send you a
>>> debug patch, if you don't mind. :-)
>> Yes, post it.
> 
> Appended.  Please send me the dmesg output from after a failing suspend
> (or in case it doesn't fail, from after the first one).

It doesn't fail, here is the output:

Shrinking memory...  Normal pages needed: 135122
Highmem pages needed: 0
Normal pages needed: 132256
Highmem pages needed: 0
Normal pages needed: 8271
Highmem pages needed: 0
Pages needed (total): 8271
Normal pages needed: 119657
Highmem pages needed: 0
Normal pages needed: 116791
Highmem pages needed: 0
Normal pages needed: 18446744073709528969
Highmem pages needed: 0
Pages needed (total): 18446744073709528969

Heh :), tmp is signed, this is -22647, I guess.

done (15505 pages freed)
Freed 62020 kbytes in 0.16 seconds (387.62 MB/s)

Complete dmesg may be obtained here:
http://www.fi.muni.cz/~xslaby/sklad/dmesg.swsusp

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
 B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E

Hnus <hnus@fi.muni.cz> is an alias for /dev/null
