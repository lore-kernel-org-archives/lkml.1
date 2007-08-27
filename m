Return-Path: <linux-kernel-owner+w=401wt.eu-S1753551AbXH0NK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbXH0NK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbXH0NKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:10:14 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:52220 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXH0NKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:10:12 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Pavel Machek <pavel@ucw.cz>
Cc: "Huang, Ying" <ying.huang@intel.com>, vgoyal@in.ibm.com,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/2 -mm] kexec based hibernation
References: <1188177245.3247.36.camel@caritas-dev.intel.com>
	<20070827050027.GB9809@in.ibm.com>
	<1188195529.3247.82.camel@caritas-dev.intel.com>
	<20070827075317.GB2060@elf.ucw.cz>
Date: Mon, 27 Aug 2007 07:05:41 -0600
In-Reply-To: <20070827075317.GB2060@elf.ucw.cz> (Pavel Machek's message of
	"Mon, 27 Aug 2007 09:53:17 +0200")
Message-ID: <m1d4x95dqy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:

> Hi!
>
>> > Does this make sense?
>> 
>> Yes, this is a sensible optimization. But I think it may be better to
>> make bootloader load kernel D directly into a specified memory location.
>> For example, we can add a option to "kernel" command of grub. 
>> 
>> And, I think we can do more in bootloader. Such as we can prepare
>> two
>
> Yes, that would be nice.
>
> It will mean quite a bit of work, but I guess it should be the long
> term goal. Loading restore kernel directly from bootloader means:
>
> 1) it is fast -- no need to boot another kernel
>
> 2) it is "classical" way of doing things
>
> On the other hand, we loose flexibility that way:
>
> 1) it locks you onto one bootloader
>
> 2) you no longer have userland there to do uncompression, decryption,
> etc..

True although for the uncompression and decryption those aren't exactly foreign
requirements for bootloaders.

Eric
