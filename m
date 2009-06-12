Return-Path: <linux-kernel-owner+w=401wt.eu-S934314AbZFLWCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934314AbZFLWCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 18:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752903AbZFLWCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 18:02:41 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:47802 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZFLWCl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 18:02:41 -0400
Message-ID: <4A32D079.9030707@mnementh.co.uk>
Date: Fri, 12 Jun 2009 23:02:33 +0100
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Brian Swetland <swetland@google.com>
CC: Pavel Machek <pavel@ucw.cz>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       san@android.com, rlove@google.com, Greg KH <greg@kroah.com>
Subject: Re: HTC Dream aka. t-mobile g1 support
References: <20090610103131.GB13885@elf.ucw.cz>	<20090610194852.GA28787@n2100.arm.linux.org.uk>	<a55d774e0906101324i7acf23b0qf42b6c2798a3eff4@mail.gmail.com>	<20090610213710.GA8472@elf.ucw.cz>	<a55d774e0906101455r455f0f88g65c74ecdf37a572@mail.gmail.com>	<20090611082532.GE8592@elf.ucw.cz>	<a55d774e0906110148m69debe8fu9ff9970c0fe30bcd@mail.gmail.com>	<20090612150504.GA15084@elf.ucw.cz> <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
In-Reply-To: <a55d774e0906121350s5c0932der44928bb8f5acad73@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Swetland wrote:

> Yup.  It's an HTC specific thing -- some of their devices don't have a
> battery gauge IC and estimate current drain based on hints provided to
> the baseband from the apps processor.  I'm not particularly thrilled
> with the interface, but without it the battery level estimation is
> flakier.

Is there a reason that this couldnt be done in userspace?
