Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbZJWNcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbZJWNcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 09:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbZJWNcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 09:32:10 -0400
Received: from relay2.mail.masterhost.ru ([83.222.23.62]:30408 "EHLO
	relay2.mail.masterhost.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbZJWNcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 09:32:09 -0400
Message-ID: <4AE1B059.7030000@mayc.ru>
Date: Fri, 23 Oct 2009 17:32:09 +0400
From: "Anton D. Kachalov" <mouse@mayc.ru>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] binfmt_elf: FatELF support in the binary loader.
References: <4AE17C1A.4060009@mayc.ru>
In-Reply-To: <4AE17C1A.4060009@mayc.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SpamTest-Envelope-From: mouse@mayc.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 10363 [Oct 23 2009]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton D. Kachalov wrote:
> I have made very similar patch but it's quite small and do not require
> deep hacks.
> It should works with "setarch" too to force selection of binary.
> There is a tool to merge binaries. Glibc / binutils patch work in 
> progress.
$ uname -m
x86_64
$ ./truearch hello32 hello64 hellos
$ ./hellos
hello x86_64
$ setarch i386 ./hellos
Hello x86
$ setarch x86_64 ./hellos
hello x86_64
$ file hello32
hello: ELF 32-bit LSB executable, Intel 80386, version 1 (SYSV), 
statically linked, for GNU/Linux 2.6.15, not stripped
$ file hello64
hello64: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically 
linked, for GNU/Linux 2.6.15, not stripped

While I didn't finish glibc hacks, I could use only statically linked 
binaries.

Rgds,
Anton
