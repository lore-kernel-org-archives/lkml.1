Return-Path: <linux-kernel-owner+w=401wt.eu-S1752869AbYDAER3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbYDAER3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 00:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750868AbYDAERT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 00:17:19 -0400
Received: from mail.lang.hm ([64.81.33.126]:45415 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769AbYDAERS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 00:17:18 -0400
Date: Mon, 31 Mar 2008 21:23:44 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Daniel Phillips <phillips@phunq.net>
cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
In-Reply-To: <200803312107.48892.phillips@phunq.net>
Message-ID: <alpine.DEB.1.10.0803312121141.14049@asgard.lang.hm>
References: <200803092346.17556.phillips@phunq.net> <200803310440.33019.phillips@phunq.net> <alpine.DEB.1.00.0803311727500.31200@asgard.lang.hm> <200803312107.48892.phillips@phunq.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, Daniel Phillips wrote:

> On Monday 31 March 2008 17:28, david@lang.hm wrote:
>> On Mon, 31 Mar 2008, Daniel Phillips wrote:
>>
>>> On Tuesday 18 March 2008 09:36, david@lang.hm wrote:
>>>> P.S. 8xPCI-e slots are only able to do 2GB/s of data transfer, in an
>>>> earlier post Daniel claimed that you needed 3GB/s of disk to mirror to the
>>>> disk, so the scenerio listed above looses 1/3 of it's performance compared
>>>> to what was being claimed earlier.
>>>
>>> Each Violin 1010 has two 8xPCI-e interfaces.
>>
>> but if you use them for redundancy by hooking them to two machines you can
>> only use one of them on your active system.
>
> That is why you use two Violin 1010 boxes, each connected to two
> servers.  The resulting mirror will have roughly 1 GByte/sec write
> bandwidth and 3 GByte/sec read bandwidth.  Fast enough for you?  No?
>
> Well then...
>
> Continue this idea to achieve whatever bandwidth you want to the ramdisk,
> subject to finding server motherboards that can take lots of PCI-e 8x
> cards, which are admittedly rare, but see "have your checkbook ready".

so is it possible to use ramback safely without buying the violin boxes? 
from your posts it doesn't seem like it.

as a sample, say you were to take a pair of the sun x4600 boxes and 
populate them with 256G of ram each. how would you use 200G of ram on the 
box as a database with ramback?

David Lang
