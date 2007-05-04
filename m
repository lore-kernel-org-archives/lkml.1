Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbXEDTD0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbXEDTD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:03:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755439AbXEDTD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:03:26 -0400
Received: from terminus.zytor.com ([192.83.249.54]:59208 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbXEDTDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:03:25 -0400
Message-ID: <463B836C.3040500@zytor.com>
Date: Fri, 04 May 2007 12:03:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i386: always clear bss
References: <463AED07.1000505@goop.org>	<m1r6pwu806.fsf@ebiederm.dsl.xmission.com> <463B49F0.401@goop.org>	<463B5643.1040204@zytor.com>	<m1ejlwr036.fsf@ebiederm.dsl.xmission.com> <463B6888.20001@zytor.com>	<m17iroqzlq.fsf@ebiederm.dsl.xmission.com>	<463B6CCE.4050800@zytor.com> <m1hcqspg7c.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1hcqspg7c.fsf@ebiederm.dsl.xmission.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> 
> My notes show 0x5c reserved for additional apm_bios_info, although
> of the top of my head I don't know how realistic that is.
> 
> 0x1e4 does look available.
> 
> It has been a long time since I made that choice, and I do see that
> looking at struct screen_info I did remember to document that I was
> using 0x3c, even in your structure.
> 
> It is all internal to our boot process and external code isn't going
> to use it so we can change it if we feel like.
> 

True.

	-hpa
