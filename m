Return-Path: <linux-kernel-owner+w=401wt.eu-S1422925AbXBASgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422925AbXBASgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 13:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422927AbXBASgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 13:36:46 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:51427 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422925AbXBASgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 13:36:45 -0500
Date: Thu, 1 Feb 2007 19:33:58 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: "Robert P. J. Day" <rpjday@mindspring.com>
cc: Judith Lebzelter <judith@osdl.org>, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, fastboot@osdl.org
Subject: Re: [ PATCH ] fix to documentation for kexec
In-Reply-To: <Pine.LNX.4.64.0702011329550.16875@CPE00045a9c397f-CM001225dbafb6>
Message-ID: <Pine.LNX.4.61.0702011932090.13737@yvahk01.tjqt.qr>
References: <20070201181955.GE5825@shell0.pdx.osdl.net>
 <Pine.LNX.4.61.0702011923530.13737@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0702011329550.16875@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 1 2007 13:30, Robert P. J. Day wrote:
>> >@@ -228,8 +228,8 @@ Notes on loading the dump-capture kernel
>> > * You must specify <root-dev> in the format corresponding to the root
>> >   device name in the output of mount command.
>> >
>> >-* "init 1" boots the dump-capture kernel into single-user mode without
>> >-  networking. If you want networking, use "init 3."
>> >+* Boot parameter "1" boots the dump-capture kernel into single-user mode
>> >+  without networking. If you want networking, use "3".
>>
>> Yup. More precisely, any arguments that could not be parsed (because
>> the kernel does not know them) are handed down to the init program
>> as arguments and/or environment variables.
>
>whoops, ignore my last post, i misread the critical words.

However, I am not sure how the kernel will handle this. Especially since:

  * if you boot with no initramfs, init= is handled by your script
    (otherwise: kernel)

  * does "init" qualify as a kernel param already? I don't think so,
    since the code indicates to be wanting "init=" at least.

Either way, the word "init" in the above doc is either (1) wrong
or (2) superfluous [unless something strange happens to interpret it later,
which I don't think]


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
