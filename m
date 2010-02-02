Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab0BBIbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:31:41 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:50222 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0BBIbj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:31:39 -0500
MIME-Version: 1.0
In-Reply-To: <20100202082144.GB5716@linux-sh.org>
References: <20100202040628.GH13428@linux-sh.org> <fa686aa41002020017m5ea0020di6924905a631dc7d6@mail.gmail.com> 
	<20100202082144.GB5716@linux-sh.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 2 Feb 2010 01:31:18 -0700
X-Google-Sender-Auth: 8487af594ef793ca
Message-ID: <fa686aa41002020031r38e6bc9eyfce6476d86d47ec2@mail.gmail.com>
Subject: Re: [GIT PULL] sh updates for 2.6.33-rc7
To: Paul Mundt <lethal@linux-sh.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 2, 2010 at 1:21 AM, Paul Mundt <lethal@linux-sh.org> wrote:
> On Tue, Feb 02, 2010 at 01:17:49AM -0700, Grant Likely wrote:
>> On Mon, Feb 1, 2010 at 9:06 PM, Paul Mundt <lethal@linux-sh.org> wrote:
>> > Please pull from:
>> >
>> > ? ? ? ?master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git sh/for-2.6.33
>> >
>> > Which contains:
>> >
>> > Magnus Damm (1):
>> > ? ? ?usb: r8a66597-hdc disable interrupts fix
>> >
>> > Marek Skuczynski (2):
>> > ? ? ?sh: Fix access to released memory in dwarf_unwinder_cleanup()
>> > ? ? ?sh: Fix access to released memory in clk_debugfs_register_one()
>> >
>> > Markus Pietrek (1):
>> > ? ? ?spi: spi_sh_msiof: Fixed data sampling on the correct edge
>>
>> Hold the phone; please coordinate with me before picking up SPI
>> patches into your tree.  I don't mind arch specific spi changes going
>> in via a different tree, but I'd like to know about it before I waste
>> time farting around with the same patch (like I did with this one
>> tonight, and only found out that you also picked it up when I came
>> across this pull request by chance).
>>
> If there's someone actively looking after the SPI stuff then that's fine.

I am now.  There wasn't anyone for a while.

> I didn't bother bouncing this one off of the SPI list since it's a
> hardware-specific correctness fix and has no dependency on anything
> subsystem related.

Fair enough, but the patch itself came across the SPI list, and so it
showed up in the patchwork tracking of spi-devel-general which I'm
using to keep on top of everything.  I brief reply to the patch email
would have let me know that I didn't have to waste any time with it.

Thanks,
g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
