Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbYLAFUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbYLAFUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 00:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750709AbYLAFUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 00:20:03 -0500
Received: from mail.lang.hm ([64.81.33.126]:52889 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701AbYLAFUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 00:20:00 -0500
Date: Sun, 30 Nov 2008 21:22:17 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Enrico Weigelt <weigelt@metux.de>
cc: linux kernel list <linux-kernel@vger.kernel.org>
Subject: Re: scanner interface proposal was: [TALPA] Intro to a linux interface
 for on access scanning (fwd)
In-Reply-To: <20081201005142.GA27387@nibiru.local>
Message-ID: <alpine.DEB.1.10.0811302121070.835@asgard.lang.hm>
References: <alpine.DEB.1.10.0808171824060.12859@asgard.lang.hm> <20081123223753.GA16424@nibiru.local> <20081123230306.48bc0274@lxorguk.ukuu.org.uk> <20081201005142.GA27387@nibiru.local>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Enrico Weigelt wrote:

> * Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>> Fine. Why not just putting this into a userland filesystem ?
>>
>> 1. Performance
>
> Does it really hurt so bad, compared with all actual AV stuff ?
> It has to go to userland anyway, in case you don't intend to
> put the scanner into the kernel ;-o

if you have to scan every file then you are right, the userland overhead 
would be swamped by the scanner overhead. but much of the time you will be 
accessing files that are already scanned or that you aren't going to scan, 
but you would still be paying the userland penalty for the filesystem.

David Lang

>> 2. Networked file systems
>
> What's the problem ?
> (btw: 9P already *IS* an network filesystem ;-P)
>
>> 3. Ioctls
>
> Ah, just forgot a while that this crap still exists ;-o
>
> BUT: do the affected dirs have to contain devices ?
> Is there any point for pulling /dev through the AV scanner ?
>
>
> cu
>
