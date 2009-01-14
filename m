Return-Path: <linux-kernel-owner+w=401wt.eu-S1760776AbZANX1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760776AbZANX1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 18:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756983AbZANX12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 18:27:28 -0500
Received: from mail.ab-net.cz ([82.100.38.6]:56379 "EHLO mail.ab-net.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155AbZANX11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 18:27:27 -0500
Message-ID: <496E74B6.6080606@email.cz>
Date: Thu, 15 Jan 2009 00:26:46 +0100
From: =?windows-1252?Q?Jir=28=ED_Burda?= <jburda@email.cz>
User-Agent: Thunderbird 2.0.0.18 (X11/20081205)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
       greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Nokia 5310 mass-storage not mounting in kernel 2.6.28
References: <Pine.LNX.4.44L0.0901140955420.2587-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0901140955420.2587-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

I can confirm Nokia 5310 with firmware 8.32 mounts correctly in 2.6.29-rc1.

Jiri Burda

Alan Stern napsal(a):
> On Tue, 13 Jan 2009, Andrew Morton wrote:
> 
>>> From: Jiri Burda <jburda@email.cz>	
>>>
>>> Nokia 5310 mobile with firmware revision 8.32 does not mount as usb mass-storage in kernel 2.6.28 and previous.
>>> This patch solves this problem by increasing firmware revision in drivers/usb/storage/unusual_device.h from 0x0701 to 0x0832.
>>> This bug is recorded in kernel bugzilla as 12367.
> 
>> The 5310 entry seems to have been removed in 2.6.29-rc1.
> 
> Indeed, as Greg mentioned we are now using a generic scheme for Nokia 
> devices.
> 
> Jiri, can you try running 2.6.29-rc1 to see whether it's okay already?
> 
> Alan Stern
> 
> 

