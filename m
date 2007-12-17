Return-Path: <linux-kernel-owner+w=401wt.eu-S934764AbXLQJBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934764AbXLQJBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 04:01:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbXLQJA4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 04:00:56 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:14121 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277AbXLQJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 04:00:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=nUftw+dMwaZonlekS9sDebzxTQa6ftjvBFH3c60dFDVmQnhDMio2BQDCuyg+Jtw+N8VVOeOj++zbz5Wzep2V+R+DbWbHzcJPvpxkbv5QhxFJx/s7EkcFsLVrgseLvONOfJCUSsAsg8/4si6NcqMFueP5mYqMsHnSDNT8KMtnFmM=
Message-ID: <47663AC3.9000802@gmail.com>
Date: Mon, 17 Dec 2007 10:00:51 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: chri <chripell@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] max3100 driver
References: <1197879438299-git-send-email-chripell@gmail.com>	 <47663726.3010508@gmail.com> <cabda6420712170055j78da46c8x6af50b095e3447c0@mail.gmail.com>
In-Reply-To: <cabda6420712170055j78da46c8x6af50b095e3447c0@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2007 09:55 AM, chri wrote:
> On Dec 17, 2007 9:45 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> You probably wanted to unregister it after _all_ cards are removed, not after
>> each...
>>
> 
> Hi,
> 
> thanks you are right. I haven't noticed this since spi devices are not
> hot-pluggable so I could remove them only with rmmod (and so all of
> them toghether). Anyway the code I sent is ugly, I will correct and
> resend.

Won't bind/unbind in sysfs help you?
