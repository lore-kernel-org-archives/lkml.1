Return-Path: <linux-kernel-owner+w=401wt.eu-S1761245AbXEQVqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761245AbXEQVqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 17:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756846AbXEQVq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 17:46:29 -0400
Received: from main.gmane.org ([80.91.229.2]:58787 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575AbXEQVq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 17:46:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Philip Pemberton <usenet07@philpem.me.uk>
Subject: Re: IPv6: 6to4 tunnel randomly cutting out on 2.6.8.1 - any   patches?
Date: Thu, 17 May 2007 22:46:14 +0100
Message-ID: <f2iif3$3u3$1@sea.gmane.org>
References: <f2ifnf$ooh$1@sea.gmane.org> <20070517.143409.102123884.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 87-194-114-122.bethere.co.uk
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
In-Reply-To: <20070517.143409.102123884.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
>>    I'm currently trying to set IPv6 up on a Linux-based router. The 
>> aforementioned router runs kernel 2.6.8.1, and just about all the hardware 
>> driver modules are binary modules. For the record, I'd love to upgrade the 
>> router to one of the newer kernels, but AIUI I can't do it because I don't 
>> have the source to the bmods. But anyway...
> 
> Then don't come here looking for support, because we can't
> help you.

All I said was "I can't upgrade the kernel". There's nothing stopping me 
patching it, as long as nothing happens to the Ethernet and ATM driver 
interface side of things - this is all protocol-layer stuff and should be well 
away from the EDI. I can't honestly see why/how fixing a bug in IPv6 would 
completely invalidate the way the Ethernet/ATM drivers interface with the kernel.

All I wanted to know is if if there WAS a known IPv6 routing issue in this 
kernel, and then fix the kernel I've got. That would leave me with a variant 
of the kernel in itself.

I'm not claiming to have found an Oops, nor am I providing an Oops log from a 
tainted kernel. All I'm trying to do is find out WHY this doesn't work, IF 
it's a known issue, and HOW to fix it myself.

Thanks.
-- 
Phil.                         |  (\_/)  This is Bunny. Copy and paste Bunny
usenet07@philpem.me.uk        | (='.'=) into your signature to help him gain
http://www.philpem.me.uk/     | (")_(") world domination.
If mail bounces, replace "07" with the last two digits of the current year.

