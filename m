Return-Path: <linux-kernel-owner+w=401wt.eu-S1752596AbZK0Qat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596AbZK0Qat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 11:30:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZK0Qas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 11:30:48 -0500
Received: from mail-fx0-f213.google.com ([209.85.220.213]:36661 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbZK0Qar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 11:30:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gT9aIoaqCITzGxAcaYHAhkJ/jmOzJ7fomfFJ6zJg4zXrWJKRjVsQyY9LVYjSmNgqgB
         QnhCe/XjxmvSy21tt3SFy/7yqHWXPFtdutQGIwVu6dlKinARqUdzhq8p5DmQaL+vPDh/
         l27w6Om2VR7kJyxi1I9a1L+Kdzt0GaDAy6vhM=
MIME-Version: 1.0
In-Reply-To: <4B0C6F4A.1080304@gmail.com>
References: <be7a9f3d0911191311p45d4438bg84d55234eacdd320@mail.gmail.com>
	 <20091123134002.bac1e664.akpm@linux-foundation.org>
	 <4B0B1B62.2030302@gmail.com>
	 <be7a9f3d0911231601p4dcfa519q4d1504a8ee37fdad@mail.gmail.com>
	 <4B0B36F0.30109@gmail.com>
	 <be7a9f3d0911240329r50ddb22dvd933f01d296295c1@mail.gmail.com>
	 <4B0C6F4A.1080304@gmail.com>
Date: Fri, 27 Nov 2009 14:30:52 -0200
X-Google-Sender-Auth: bc4d93101e56f66c
Message-ID: <be7a9f3d0911270830g37726e46n9fa8f463b37f79b9@mail.gmail.com>
Subject: Re: Vortex86SX: only works with irqpoll
From: Otavio Salvador <otavio@ossystems.com.br>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016e654fe6ebb3b0504795cd01a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e654fe6ebb3b0504795cd01a
Content-Type: text/plain; charset=ISO-8859-1

Hello,

On Tue, Nov 24, 2009 at 9:42 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> On 11/24/2009 05:29 AM, Otavio Salvador wrote:
> Well, the ethernet adapter would likely be a different problem. Do you get
> any interrupts showing up in /proc/interrupts for either the disk or the
> network adapter?

I guess I did the test with a mangled configuration file and then the
network didn't work. Now I tested it again and it has work fine.

What still fails is the disk. It still doesn't work et all.

I'm sending the /proc/interrupts. It got IRQ 14 for the disk adaptor.

Cheers,

-- 
Otavio Salvador                  O.S. Systems
E-mail: otavio@ossystems.com.br  http://www.ossystems.com.br
Mobile: +55 53 9981-7854         http://projetos.ossystems.com.br

--0016e654fe6ebb3b0504795cd01a
Content-Type: application/octet-stream; name=interrupts
Content-Disposition: attachment; filename=interrupts
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2j65wt90

ICAgICAgICAgICBDUFUwICAgICAgIAogIDA6ICAgICAgNDkyNzkgICAgWFQtUElDLVhUICAgICAg
ICB0aW1lcgogIDE6ICAgICAgICA2MjAgICAgWFQtUElDLVhUICAgICAgICBpODA0MgogIDI6ICAg
ICAgICAgIDAgICAgWFQtUElDLVhUICAgICAgICBjYXNjYWRlCiAgNTogICAgICAgICAgMCAgICBY
VC1QSUMtWFQgICAgICAgIG9oY2lfaGNkOnVzYjMKICA5OiAgICAgICAgMTgyICAgIFhULVBJQy1Y
VCAgICAgICAgZWhjaV9oY2Q6dXNiMQogMTA6ICAgICAgICAgIDIgICAgWFQtUElDLVhUICAgICAg
ICBlaGNpX2hjZDp1c2IyCiAxMTogICAgICAgICAyNiAgICBYVC1QSUMtWFQgICAgICAgIG9oY2lf
aGNkOnVzYjQKIDEyOiAgICAgICAgICA0ICAgIFhULVBJQy1YVCAgICAgICAgaTgwNDIKIDE0OiAg
ICAgICAgICAwICAgIFhULVBJQy1YVCAgICAgICAgcGF0YV9pdDgyMXgKTk1JOiAgICAgICAgICAw
ICAgTm9uLW1hc2thYmxlIGludGVycnVwdHMKTE9DOiAgICAgICAgICAwICAgTG9jYWwgdGltZXIg
aW50ZXJydXB0cwpTUFU6ICAgICAgICAgIDAgICBTcHVyaW91cyBpbnRlcnJ1cHRzCkNOVDogICAg
ICAgICAgMCAgIFBlcmZvcm1hbmNlIGNvdW50ZXIgaW50ZXJydXB0cwpQTkQ6ICAgICAgICAgIDAg
ICBQZXJmb3JtYW5jZSBwZW5kaW5nIHdvcmsKRVJSOiAgICAgICAgICAwCk1JUzogICAgICAgICAg
MAo=
--0016e654fe6ebb3b0504795cd01a--
