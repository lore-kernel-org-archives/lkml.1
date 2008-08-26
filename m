Return-Path: <linux-kernel-owner+w=401wt.eu-S1757039AbYHZCeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757039AbYHZCeB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 22:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbYHZCdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 22:33:54 -0400
Received: from mail.tmr.com ([64.65.253.246]:58573 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752AbYHZCdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 22:33:53 -0400
Message-ID: <48B36EB1.4040201@tmr.com>
Date: Mon, 25 Aug 2008 22:47:13 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: jassi_singh_brar@yahoo.com
CC: linux-kernel@vger.kernel.org
Subject: Re: An idea .... with code
References: <801995.65435.qm@web33201.mail.mud.yahoo.com>
In-Reply-To: <801995.65435.qm@web33201.mail.mud.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jassi brar wrote:
> Hi,
> 
>   Lately a question has been bugging me: Why do we keep complicated(specific ioctls to set up and set free) LOOP driver to emulate a data file as block-device, for it to be mounted/formated.
> 
>  Wouldn't it be nice if we didnt have to specify '-o loop' or use losetup -d etc?
> 
>  With inspiration from UMS-Gadget and LOOP driver itself, I implemented a proof of concept: A kernel module which creats a node in /sys/devices/ and un/loads files to be emulated as block devices. The interface doesn't implement any new ioctls or a syscall.
> 
This seems like a really interesting idea, but will it interface with 
crypto applications like LUKS? Crypto seems to be a vital feature for 
anything related to devices and/or filesystems if an approach is going 
to be more than a niche slution.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
