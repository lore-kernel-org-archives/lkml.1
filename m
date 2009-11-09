Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbZKIIUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbZKIIUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 03:20:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZKIIUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 03:20:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:46352 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZKIIUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 03:20:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=LSZ3tAvnWWBE47XcZOo7yYmHgRjXnrYTmEJrZ0uxNapu0F5SgUf/1/xUJhEpboOVpt
         MEftv7Mqjd65z0fZ9mC7B6sEduCWSJoj4+A42+RHXIO7rZwa3Zi9iV7llFlO/KLQsgIw
         qfZFGhTrr8WQBmejNDYIACkAnYBmZAWokWrZg=
Message-ID: <4AF7D0DD.5030604@gmail.com>
Date: Mon, 09 Nov 2009 09:20:45 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5pre) Gecko/20091028 SUSE/3.0b4-5.1 Thunderbird/3.0pre
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm] char, moxa: Make isabrds variable global.
References: <b9df5fa10911022029q197a0c5dkbbda609f4e41287@mail.gmail.com>	 <b9df5fa10911062108l2334be64ka0777e89c6dbc17f@mail.gmail.com>	 <4AF54B77.2000605@gmail.com> <b9df5fa10911081806m7564f778k35e0308fc5ddfba4@mail.gmail.com>
In-Reply-To: <b9df5fa10911081806m7564f778k35e0308fc5ddfba4@mail.gmail.com>
X-Enigmail-Version: 0.97b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2009 03:06 AM, Rakib Mullick wrote:
> On 11/7/09, Jiri Slaby <jirislaby@gmail.com> wrote:
>>
>> Sorry I had no time to look into the first patch. And it makes no sense.
>>  The driver is unusable on !MODULE && !PCI. So better fix is to disallow
>>  whole build on such configurations. Care to fix that?
>>
> Hi Jiri, thanks for your care. Would you please checkout the
> patch below? Is it okay?

Actually I'm idiot. I forgot, that today people can just pass "module
parameters" on the kernel cmdline even on !MODULE in the
KBUILD_MODNAME.param manner. So no, a better fix is to remove !MODULE
ifdefs completely.

Sorry for the confusion.
