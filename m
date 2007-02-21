Return-Path: <linux-kernel-owner+w=401wt.eu-S1422799AbXBUSvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422799AbXBUSvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 13:51:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422797AbXBUSvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 13:51:15 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:41990 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422799AbXBUSvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 13:51:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=Yv470Z0ASgq+CVs+UWXrNoxq+BrzRrmxzug19mR7qJn8XbMb6UmmnaJzvGWCgx+ZP3vgdUwkpGOgM7T+LIO/bXx0ev15IXJQQ5b12Ph2NFfua+bI5/t5Hsvr+7bXRzy8iqNqePfFyAQ7VBwNm+3LZNCWx6dGqNfEW8KxSmsuVko=
Message-ID: <45DC949A.2040801@gmail.com>
Date: Wed, 21 Feb 2007 19:51:06 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Faik Uygur <faik@pardus.org.tr>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21-rc1
References: <Pine.LNX.4.64.0702202043280.4043@woody.linux-foundation.org> <200702211526.41493.faik@pardus.org.tr> <45DC9259.5010300@gmail.com>
In-Reply-To: <45DC9259.5010300@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Faik Uygur napsal(a):
>> Hi,
> 
> Hi.
> 
>> 21 Şub 2007 Çar 06:53 tarihinde, Linus Torvalds şunları yazmıştı:
>>> Ok, the merge window for 2.6.21 has closed, and -rc1 is out there.
>>
>>   CHK     include/linux/version.h
>>   CHK     include/linux/utsrelease.h
>>   CHK     include/linux/compile.h
>>   CC [M]  drivers/char/ip2/ip2main.o
>> In file included from drivers/char/ip2/ip2main.c:285:
>> drivers/char/ip2/i2lib.c: In function `iiSendPendingMail_t':
>> drivers/char/ip2/i2lib.c:83: sorry, unimplemented: inlining failed in 
>> call to 'iiSendPendingMail': function body not available
>> drivers/char/ip2/i2lib.c:157: sorry, unimplemented: called from here
>> make[3]: *** [drivers/char/ip2/ip2main.o] Error 1
>> make[2]: *** [drivers/char/ip2] Error 2
>> make[1]: *** [drivers/char] Error 2
>> make: *** [drivers] Error 2
>>
>> With cleanup changes in commit 
>> 40565f1962c5be9b9e285e05af01ab7771534868 compilation fails.
> 
> What compiler?

Oh, I can reproduce with gcc 3.4. Going to fix it.

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
