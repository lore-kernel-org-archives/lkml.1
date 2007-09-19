Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXISSjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXISSjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 14:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755810AbXISSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 14:39:21 -0400
Received: from palrel10.hp.com ([156.153.255.245]:49825 "EHLO palrel10.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718AbXISSjU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 14:39:20 -0400
Message-ID: <46F16CC1.9090302@hp.com>
Date: Wed, 19 Sep 2007 11:38:57 -0700
From: Rick Jones <rick.jones2@hp.com>
User-Agent: Mozilla/5.0 (X11; U; HP-UX 9000/785; en-US; rv:1.7.13) Gecko/20060601
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: Ulrich Drepper <drepper@redhat.com>, netdev <netdev@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: follow-up: discrepancy with POSIX
References: <46F13E8B.4050309@redhat.com> <p73sl5aveqh.fsf@bingen.suse.de>	<46F15305.2030507@redhat.com>	<20070919172653.GB18045@one.firstfloor.org>	<46F1608E.7060908@redhat.com>	<20070919175700.GC18045@one.firstfloor.org>	<46F16418.3070706@redhat.com> <20070919183004.GA18707@one.firstfloor.org>
In-Reply-To: <20070919183004.GA18707@one.firstfloor.org>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Wed, Sep 19, 2007 at 11:02:00AM -0700, Ulrich Drepper wrote:
> 
>>>on UDP/RAW and it's certainly possible to connect() to that. 
>>
>>Where do you get this from?  And where is this implemented?  I don't
> 
> 
> Sorry it's actually loopback, not broadcast as implemented in Linux.
> In Linux it's implemented in ip_route_output_slow(). Essentially
> converted to 127.0.0.1
> 
> I think it's traditional BSD behaviour but couldn't find it on
> a quick look in FreeBSD source (but haven't looked very intensively) 

One has to set their way-back machine pretty far back to find the *BSD 
bits which used 0.0.0.0 as the "all nets, all subnets" (to mis-use a 
term) broadcast IPv4 address when sending.  Perhaps as far back as the 
time before HP-UX 7 or SunOS4.  The bit errors in my dimm memory get 
pretty dense that far back...

It has hung-on in various places (stacks) as an "accepted" broadcast IP 
in the receive path, but not the send path for quite possibly decades now.

rick jones
