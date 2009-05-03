Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZECSSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZECSSn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 14:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754439AbZECSSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 14:18:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:45334 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbZECSSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 14:18:30 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@mit.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lots of unexpected non-allocatable section warnings
References: <20090503110517.6d09bca2@hyperion.delvare>
	<20090503103010.GA27978@uranus.ravnborg.org>
	<20090503124848.276b437f@hyperion.delvare>
X-Yow: I'll clean your ROOM!!  I know some GOOD stories, too!!  All about
 ROAD Island's, HUSH Puppies, and how LUKE finds GOLD on his LAND!!
Date: Sun, 03 May 2009 20:18:24 +0200
In-Reply-To: <20090503124848.276b437f@hyperion.delvare> (Jean Delvare's
	message of "Sun, 3 May 2009 12:48:48 +0200")
Message-ID: <m21vr6124v.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> writes:

> Hi Sam,
>
> Thanks for your swift answer.
>
> On Sun, 3 May 2009 12:30:10 +0200, Sam Ravnborg wrote:
>> On Sun, May 03, 2009 at 11:05:17AM +0200, Jean Delvare wrote:
>> > Hi Anders, Sam,
>> > 
>> > After your fix "kbuild, modpost: Check the section flags, to catch
>> > missing ax/aw", I get a lot of warnings like the following during
>> > modpost on x86-64:
>> > 
>> > WARNING: arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.o (.comment.SUSE.OPTs): unexpected non-allocatable section.
>> > Did you forget to use "ax"/"aw" in a .S file?
>> > Note that for example <linux/init.h> contains
>> > section definitions for use in .S files.
>> > 
>> > Apparently there's one such warning for every module on my system, that
>> > is, 907. That's a lot, and pretty annoying. How do I solve this? I don't
>> > know much about assembly.
>> 
>> Cannot reproduce here..
>
> Given the name of the section, I presume it is somewhat SUSE-specific.
> I'm running openSUSE 11.1.

The section is created by the SUSE compiler and contains a summary of
the options used for compiling the file.  It should be treated like a
.comment section.

Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
