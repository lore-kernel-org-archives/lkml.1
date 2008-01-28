Return-Path: <linux-kernel-owner+w=401wt.eu-S1757365AbYA1UBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365AbYA1UBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbYA1UBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:01:05 -0500
Received: from corvus.services.brown.edu ([128.148.106.174]:36545 "EHLO
	corvus.services.brown.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYA1UBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:01:04 -0500
Message-ID: <479E3468.3090602@bobjweil.com>
Date: Mon, 28 Jan 2008 15:00:40 -0500
From: Richard Heck <rgheck@bobjweil.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrey Borzenkov <arvidjaar@mail.ru>
CC: linux-kernel@vger.kernel.org, rgheck@comcast.net
Subject: Re: Problem with ata layer in 2.6.24
References: <200801272122.21823.gene.heskett@gmail.com> <1201539043.31293.7.camel@zem> <1201540830.6526.19.camel@localhost> <200801281230.32910.gene.heskett@gmail.com> <alpine.LNX.1.00.0801281248190.13593@iabervon.org> <479E1D9E.3000900@bobjweil.com> <20080128185345.CF0A51871238@smtp03.mtu.ru>
In-Reply-To: <20080128185345.CF0A51871238@smtp03.mtu.ru>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Brown-Proofpoint: Not Infected
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 classifier= adjust=0 reason=safe engine=3.1.0-0708230000 definitions=main-0801280094
X-Brown-MailScanner-SpamCheck: not spam, rule=notspam policy=default score=0 classifier= adjust=0 reason=safe engine=3.1.0-0708230000 definitions=main-0801280094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Borzenkov wrote:
> Richard Heck wrote:
>
>   
>> Daniel Barkalow wrote:
>>     
>>> Can you switch back to old IDE to get your work done (and to make sure
>>> it's not a hardware issue that's developed recently)?
>>>       
>> I think it'd be really, REALLY helpful to a lot of people if you, or
>> someone, could explain in moderate detail how this might be done. I
>> tried doing it myself, but I'm not sufficiently expert at configuring
>> kernels that I was ever able to figure out how to do it.
>>
>>     
>
> well, here on Mandriva I
>
> 1) compile both IDE and libata as modules
> 2) create initrd that contains either IDE or libata modules
> 3) use labels for file system mounts, swaps and resume device.
>
>
> Now 1) should be pretty straightforward (I could send you config if you
> like, it is stripped down to bare minimum on my system, you will have to
> check drivers for your hardware). 2 and 3 are obviously distribution
> dependent. I can explain how to do it on Mandriva that ATM has near to
> perfect support for addressing devices via label/UUID; also ide/scsi/ata
> switch is trivial using Mandriva mkinitrd. 
>
>   
Thanks for this. Compiling the IDE stuff as a module is indeed the easy 
part, though I suppose I need to make sure I get the right drivers for 
my chipset, too. Loading e.g. the Fedora 6 LiveCD and then lsmod'ing 
should do it, though. Labels are used by default in Fedora now, so 
that's fine, too. Getting mkinitrd to work right shouldn't be too bad, 
either. So I'll have a go at this when I get some time and report on it. 
What might be REALLY helpful to people would be if we Fedora types could 
produce a modified kernel rpm that would handle this....though, I should 
say, I've also seen a lot of complaints along these same lines on Ubuntu.

Richard

