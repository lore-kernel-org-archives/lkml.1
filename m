Return-Path: <linux-kernel-owner+w=401wt.eu-S1753300AbYKYLNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbYKYLNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 06:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751449AbYKYLNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 06:13:04 -0500
Received: from stinky.trash.net ([213.144.137.162]:55633 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYKYLNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 06:13:02 -0500
Message-ID: <492BDDB4.90304@trash.net>
Date: Tue, 25 Nov 2008 12:12:52 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Meelis Roos <mroos@linux.ee>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Regression - Re: 2.6.28-rc2: runaway loop modprobe char-major-5-1
References: <Pine.SOC.4.64.0810281212540.21462@math.ut.ee>	 <49071A84.3080706@trash.net>	 <Pine.SOC.4.64.0811212351200.16409@math.ut.ee>	 <492AACB4.9070903@trash.net> <ac3eb2510811240705q2133b4e5w6ac0ab6b41ccaa69@mail.gmail.com>
In-Reply-To: <ac3eb2510811240705q2133b4e5w6ac0ab6b41ccaa69@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kay Sievers wrote:
> On Mon, Nov 24, 2008 at 14:31, Patrick McHardy <kaber@trash.net> wrote:
>> Meelis Roos wrote:
>>> Rerepeating, same userspace generats fine initramfs for 2.6.27 and the
>>> initramfs contents are the same except modules tree that is for different
>>> version.
>>>
>>> It happens on 2 of my computers, both have custom config (serial compiled
>>> in, not modular). The hang happens before ttyS driver initialization.
>> char-major-5-1 is /dev/console here.
>>
>>> Seems like a kernel regression to me.
>> It does, I changed some configuration options from =m to =y and
>> it started working again. Unfortunately I'm unable to find the
>> exact option that fixed it since I don't have the previous
>> configuration anymore and random attempts to trigger the problem
>> again failed.
> 
> Maybe you just miss /dev/console in initramfs? That would trigger the
> kernel forked modprobe with that major/minor.
> 
> Some device nodes must be created or included in initramfs before any
> action is taken.

No, the image is fine. As I said, changing the config fixed the problem.
