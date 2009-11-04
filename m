Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbZKDLgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbZKDLgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 06:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbZKDLgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 06:36:07 -0500
Received: from mx1.moondrake.net ([212.85.150.166]:33897 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755528AbZKDLgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 06:36:06 -0500
X-Spam-Virus: No
From: Arnaud Patard <apatard@mandriva.com>
To: wuzhangjin@gmail.com
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
       LKML <linux-kernel@vger.kernel.org>, huhb@lemote.com, yanh@lemote.com,
       Zhang Le <r0bertz@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
       Nicholas Mc Guire <der.herr@hofr.at>, zhangfx@lemote.com,
       liujl@lemote.com
Subject: Re: [PATCH -queue v0 1/6] [loongson] add basic loongson-2f support
References: <cover.1257325319.git.wuzhangjin@gmail.com>
	<a1bd2470bc465e505281c761adca8c2287d102b3.1257325319.git.wuzhangjin@gmail.com>
	<m3iqdqtwgk.fsf@anduin.mandriva.com>
	<1257332652.8716.5.camel@falcon.domain.org>
Organization: Mandriva
Date: Wed, 04 Nov 2009 12:36:23 +0100
In-Reply-To: <1257332652.8716.5.camel@falcon.domain.org> (Wu Zhangjin's message of "Wed, 04 Nov 2009 19:04:12 +0800")
Message-ID: <m3639qttc8.fsf@anduin.mandriva.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin <wuzhangjin@gmail.com> writes:

> Hi,
>
> On Wed, 2009-11-04 at 11:28 +0100, Arnaud Patard wrote:
> [...]
>> > +
>> > +config CPU_LOONGSON2F
>> > +	bool "Loongson 2F"
>> > +	depends on SYS_HAS_CPU_LOONGSON2F
>> > +	select CPU_LOONGSON2
>> > +	help
>> > +	  The Loongson 2F processor implements the MIPS III instruction set
>> > +	  with many extensions.
>> > +
>> > +	  Loongson2F have built-in DDR2 and PCIX controller. The PCIX controller
>> > +	  have a similar programming interface with FPGA northbridge used in
>> > +	  Loongson2E.
>> > +
>> 
>> Small question : Why don't you restrict to 64bit kernels only ? From
>> what I remember from some discussions with ST, trying to use a 32-bit
>> kernel on 2f is a nice way to get troubles. It would be better imho to
>> forbid such a configuration. As a side effect, this will remove all
>> 'defined(CONFIG_64BIT)' parts of your #ifdef tests. 
>> 
>
> It's hard to make such a decision ;) Perhaps some guys want to play with
> the 32bit version.

It's a matter of taste : using 32 bit and getting an more or less broken
machine or using 64bit and getting a working machine. I don't think a
lot of people will choose the first option :)

Arnaud
