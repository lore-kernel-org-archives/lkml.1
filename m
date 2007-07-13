Return-Path: <linux-kernel-owner+w=401wt.eu-S964954AbXGMWwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964954AbXGMWwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 18:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937753AbXGMWun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 18:50:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48217 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933616AbXGMWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 18:50:40 -0400
Message-ID: <469801B7.7010909@zytor.com>
Date: Fri, 13 Jul 2007 15:50:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Bodo Eggert <7eggert@gmx.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3][try 1] init: enable system-on-initramfs
References: <Pine.LNX.4.58.0707132039080.3222@be1.lrz> <4697D6EB.5020404@zytor.com> <Pine.LNX.4.58.0707132344140.13842@be1.lrz>
In-Reply-To: <Pine.LNX.4.58.0707132344140.13842@be1.lrz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bodo Eggert wrote:
> On Fri, 13 Jul 2007, H. Peter Anvin wrote:
>> Bodo Eggert wrote:
> 
>>> I toyed with setting up a diskless system in initramfs. In the process, I
>>> came across some things:
>>>
>>> 1)  There is no way to have the kernel not mount a filesystem,
>>>     unless you use /init or rdinit=.
>> And?  Just use rdinit=/sbin/init and no patch is needed.
> 
> rdinit is supposed to do a different job from /sbin/init, therefore it
> will not do the security callbacks the original code would do.
> 
> And besides that, it feels like turning the wrong knob for that task.

No, it is exactly the right knob for the task.

The fact that the security callbacks don't get invoked when using an
initramfs *AT ALL* is the real problem.

	-hpa
