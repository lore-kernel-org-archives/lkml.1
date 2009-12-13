Return-Path: <linux-kernel-owner+w=401wt.eu-S1753171AbZLMUgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171AbZLMUgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:36:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752853AbZLMUgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:36:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:27424 "HELO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752843AbZLMUgj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:36:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=nFfzPnXxnztGtHbNNGTCv/6JuThXcJ9onnm+xUC7cP5EWvTJekMiXdGodgAzziVOkX
         1iyTEXFUDWws3vTlVahIby6iGKZ7CgPXStzhD7AtjdZdx1+pYx0PW1PqNXn881T+jVoE
         ytQXR/jEdRaVrbopTYLZbsdxnfQNZ6zLf2mVc=
MIME-Version: 1.0
In-Reply-To: <4B2441A6.5050404@vflare.org>
References: <1260598486-12623-1-git-send-email-ngupta@vflare.org>
	 <84144f020912112341jc7fdc1eqac719578e2aa746b@mail.gmail.com>
	 <4B2441A6.5050404@vflare.org>
Date: Sun, 13 Dec 2009 22:36:26 +0200
X-Google-Sender-Auth: e6c954591f2b1283
Message-ID: <84144f020912131236m2739aaa5obe6f8399d9e90aea@mail.gmail.com>
Subject: Re: [PATCH] ramzswap: remove ARM specific d-cache hack
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: ngupta@vflare.org
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 13, 2009 at 3:21 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> On 12/12/2009 01:11 PM, Pekka Enberg wrote:
>> On Sat, Dec 12, 2009 at 8:14 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>>> Remove d-cache hack in ramzswap driver that was needed
>>> to workaround a bug in ARM version of update_mmu_cache()
>>> which caused stale data in d-cache to be transferred to
>>> userspace. This bug was fixed by git commit:
>>>        787b2faadc4356b6c2c71feb42fb944fece9a12f
>>> This also brings down one entry in TODO file.
>>>
>>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>
>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>
> Thanks for review Pekka.
> Now wondering when this patch will be committed to mainline.

I don't see any reason why this shouldn't go into .33 but that's
really up to Greg.

                      Pekka
