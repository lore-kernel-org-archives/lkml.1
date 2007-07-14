Return-Path: <linux-kernel-owner+w=401wt.eu-S1765285AbXGNUf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765285AbXGNUf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 16:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761280AbXGNUfR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 16:35:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33954 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763039AbXGNUfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 16:35:15 -0400
Message-ID: <4699337E.2060908@zytor.com>
Date: Sat, 14 Jul 2007 13:35:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <4697D6EB.5020404@zytor.com> <Pine.LNX.4.58.0707132344140.13842@be1.lrz> <469801B7.7010909@zytor.com> <Pine.LNX.4.58.0707141629510.5288@be1.lrz> <469919D5.3070709@zytor.com> <Pine.LNX.4.58.0707142141030.2346@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707142141030.2346@be1.lrz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> On Sat, 14 Jul 2007, H. Peter Anvin wrote:
>> Bodo Eggert wrote:
> 
>>> Setting the name of the rdinit process to the name of the init process
>>> in order to select the root device should not be the right knob.
>>>
>> What's wrong with it?
> 
> rdinit is supposed to be the program that mounts, root is supposed to be 
> whatever is mounted and init is supposed to run the system. Three 
> different things. Now if you want to change the third, just set the first 
> to the second ...

That only applies to a model that you explicitly doesn't want to use.

	-hpa
