Return-Path: <linux-kernel-owner+w=401wt.eu-S1754964AbYLVMEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754964AbYLVMEh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 07:04:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754678AbYLVMEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 07:04:21 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:63580 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbYLVMEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 07:04:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ttin9L4D4tl0rfkiAZA0ug42AHfgfuqadG3REuniPftwbV2LOtL9CX5axWSXlYX+My
         lAudUfqObM4XLmBhLtziaXfJQ4CfaW8Lf7xmsnBFKdgP7SRI8W/mwR19uu8oQ0M8/dDa
         ENt9XuQAit6HNPDRdJBxqhs+wthFzTPd0PZgY=
Message-ID: <494F823E.9060607@gmail.com>
Date: Mon, 22 Dec 2008 13:04:14 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       arjan@linux.intel.com, mpm@selenic.com, tytso@mit.edu
Subject: Re: mmotm 2008-12-01-19-41: early exception (page fault -- deref
 of 0x20)
References: <4935C03A.7030603@gmail.com> <20081202153336.7b765ec7.akpm@linux-foundation.org> <alpine.LRH.1.10.0812031400040.28179@twin.jikos.cz>
In-Reply-To: <alpine.LRH.1.10.0812031400040.28179@twin.jikos.cz>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2008 02:00 PM, Jiri Kosina wrote:
> On Tue, 2 Dec 2008, Andrew Morton wrote:
> 
>> Presumably your machine picked a different clocksource from Arjan's, 
>> mine and others.  Now, how do we work out what clocksource you're using?
>> dmesg -s 1000000 | grep -i clock
>> nope
>> dmesg -s 1000000 | grep -i using
>> nope
>> hrm.
> 
> cat /sys/devices/system/clocksource/clocksource0/current_clocksource

tsc

It ran from qemu, but it oopsed even on my desktop (tsc too).
