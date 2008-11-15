Return-Path: <linux-kernel-owner+w=401wt.eu-S1755677AbYKOAM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677AbYKOAM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 19:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbYKOAMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 19:12:47 -0500
Received: from lucidpixels.com ([75.144.35.66]:48188 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbYKOAMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 19:12:46 -0500
Date: Fri, 14 Nov 2008 19:12:45 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
cc: linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: 2.6.27.6 question: ata_sff_hsm_move: ata15 (why always ata15)?
In-Reply-To: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
Message-ID: <alpine.DEB.1.10.0811141912190.6297@p34.internal.lan>
References: <alpine.DEB.1.10.0811141850590.6217@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 14 Nov 2008, Justin Piszcz wrote:

> I am trying to find out what the root cause of this error/problem is:
> https://bugzilla.redhat.com/show_bug.cgi?id=462425
>
> It seems like every week or other week someone else reports this on the 
> linux-raid mailing list.
>
> I have enabled debugging in the libata.h file and I find that ata15 is 
> constantly being accessed for some reason, why is this?
>
> The first two disks are md/RAID1, the other volume is not being written to or 
> read:
>

In messages:

Nov 14 19:12:01 p34 kernel: [ 2485.558898] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:01 p34 kernel: [ 2485.559318] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.554449] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.554725] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.555399] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.555746] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.556194] ata15: ata_dev_select: ENTER, device 0, wait 1
Nov 14 19:12:03 p34 kernel: [ 2487.556449] ata15: ata_dev_select: ENTER, device 0, wait 1

