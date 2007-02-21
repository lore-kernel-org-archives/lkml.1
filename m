Return-Path: <linux-kernel-owner+w=401wt.eu-S1422793AbXBUSle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422793AbXBUSle (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422795AbXBUSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:41:33 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:28319 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422793AbXBUSlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:41:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=LSPT0ytqEEjnBRU9gYBe9EBCX+FCN7tyWNbD6XuuXLmvYlBQt79HT1ixIkDvJMCNmZUph/9QjU4xPwakP6K8DwljwMj9LaUFVIKrMverhmqOmkECu0hpkitrNmXCc/VKTpNl9cwrclB/A00VVPyUOAnP9CLFaj9XQNG1otN2Ifc=
Message-ID: <45DC9259.5010300@gmail.com>
Date: Wed, 21 Feb 2007 19:41:29 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Faik Uygur <faik@pardus.org.tr>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc1
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200702211526.41493.faik@pardus.org.tr>
In-Reply-To: <200702211526.41493.faik@pardus.org.tr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Faik Uygur napsal(a):
> Hi,

Hi.

> 21 Şub 2007 Çar 06:53 tarihinde, Linus Torvalds şunları yazmıştı: 
>> Ok, the merge window for 2.6.21 has closed, and -rc1 is out there.
> 
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CHK     include/linux/compile.h
>   CC [M]  drivers/char/ip2/ip2main.o
> In file included from drivers/char/ip2/ip2main.c:285:
> drivers/char/ip2/i2lib.c: In function `iiSendPendingMail_t':
> drivers/char/ip2/i2lib.c:83: sorry, unimplemented: inlining failed in call 
> to 'iiSendPendingMail': function body not available
> drivers/char/ip2/i2lib.c:157: sorry, unimplemented: called from here
> make[3]: *** [drivers/char/ip2/ip2main.o] Error 1
> make[2]: *** [drivers/char/ip2] Error 2
> make[1]: *** [drivers/char] Error 2
> make: *** [drivers] Error 2
> 
> With cleanup changes in commit 40565f1962c5be9b9e285e05af01ab7771534868 
> compilation fails.

What compiler?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
