Return-Path: <linux-kernel-owner+w=401wt.eu-S1751160AbXEXNsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751160AbXEXNsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 09:48:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbXEXNse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 09:48:34 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:62546 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbXEXNsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 09:48:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=UNWW8iawX+eW2yKr6dxbHPRoGwMXpsjuPdwTMJ0ph6NBFuwSqxmhbh/ArMHFqMaID1gEc9vlILw/6KiRGHtL2a97rX3rtlb74R51Gevtm1jbH/MIVBntHguhnoMUlpcphh1J5RVEgr0skaLF7o6DTe/I+U9oGDwaFAdJ047joqg=
Message-ID: <4cefeab80705240648k2f3c22ddw13374c9d6b2f521a@mail.gmail.com>
Date: Thu, 24 May 2007 19:18:30 +0530
From: "Nitin Gupta" <nitingupta910@gmail.com>
To: "Bret Towe" <magnade@gmail.com>
Subject: Re: [RFC] LZO de/compression support - take 3
Cc: linux-kernel@vger.kernel.org, "Richard Purdie" <richard@openedhand.com>,
       linux-mm-cc@laptop.org, "Satyam Sharma" <satyam.sharma@gmail.com>
In-Reply-To: <dda83e780705230750j43c9e89eh766fdaafb1d671f3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_172448_31250370.1180014510535"
References: <4cefeab80705230127r58e8f9e1sa644092e95eb81eb@mail.gmail.com>
	 <dda83e780705230750j43c9e89eh766fdaafb1d671f3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_172448_31250370.1180014510535
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 5/23/07, Bret Towe <magnade@gmail.com> wrote:
> On 5/23/07, Nitin Gupta <nitingupta910@gmail.com> wrote:

> > For now, tested on x86 only.
>
> If you have a program to test this I can run it on an amd64 and a g4 ppc
>

Attached is the kernel module (compress-test) to test this LZO code.
Just compile this module against 2.6.22-rc2 with this LZO patch. Then
testing can be done as:
1- Mount DebugFS somewhere e.g:
mkdir /debug; mount -t debugfs debugfs /debug
2- Load the module and do:
cat /path/to/some_file > /debug/compress_test/compress
(/var/log/messages should show that compression was successful)
3- Then decompress this file as:
cat /debug/compress_test/decompress > /tmp/t
(/var/log/messages should show that decompression was successful)
4- For extra verification do:
diff /tmp/t /path/to/some_file   -- O/P must be empty


Thanks!
Nitin

------=_Part_172448_31250370.1180014510535
Content-Type: application/x-gzip; name=compress-test.tar.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f239z8ot
Content-Disposition: attachment; filename="compress-test.tar.gz"

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
Q2E8ACgAAA==
------=_Part_172448_31250370.1180014510535--
