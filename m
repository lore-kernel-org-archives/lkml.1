Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXBNQoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXBNQoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 11:44:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932380AbXBNQoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 11:44:05 -0500
Received: from mail.tmr.com ([64.65.253.246]:42800 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378AbXBNQoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 11:44:04 -0500
Message-ID: <45D33CC1.7040709@tmr.com>
Date: Wed, 14 Feb 2007 11:45:53 -0500
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Benny Amorsen <benny+usenet@amorsen.dk>
CC: linux-smp@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: smp and irq conflict
References: <45BE4003005C2845@vsmtp2.tin.it> <45C35024.8090907@tmr.com> <m3zm7suc5o.fsf@ursa.amorsen.dk>
In-Reply-To: <m3zm7suc5o.fsf@ursa.amorsen.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Benny Amorsen wrote:
>>>>>> "BD" == Bill Davidsen <davidsen@tmr.com> writes:
>>>>>>             
>
> BD> You may be able to move one board to another slot, but looking at
> BD> the bandwidth I suspect you may need a server motherboard with
> BD> multiple busses, preferably running at 66MHz 64bit. I don't think
> BD> this is a interrupt problem, but you can just try capture on two
> BD> channels which share an interrupt, like bttv0 and bttv7 to verify
> BD> that.
>
> 66MHz 64bit isn't much fun when the capture cards are 33MHz 32bit.
>
>   

It doesn't help the video to bus, but multiple busses to give a bus per 
card would help, and assuming the data are being saved to disk using a 
decent disk controller which can use the additional bandwidth, at least 
some conflict is avoided or reduced.

This is really a case of using general hardware to the utmost, I suspect 
more m/b bandwidth will be needed somewhere.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

