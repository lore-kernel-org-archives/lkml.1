Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZA3KwE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZA3KwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:52:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbZA3Kvx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:51:53 -0500
Received: from rv-out-0506.google.com ([209.85.198.225]:40776 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZA3Kvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:51:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EV19QHuKUVLOK6Ty5c8PQJ3hMML3BODmKWQzXKqwY8NRkVLM6QIH75ZXIQT8TW6HBD
         wXA/e818ZtP/t6wuuFabuHDo+tcPbHRo12MPyBie1cYzEey8lsohBbkdZRomcBctSdka
         oOOAJGL515TpaxpA7dSWQiFWS44ychc1NzM2o=
MIME-Version: 1.0
In-Reply-To: <20090130113043.72fd0f55@gondolin>
References: <1233282702-6274-1-git-send-email-tom.leiming@gmail.com>
	 <20090130110555.116f747a@gondolin>
	 <d82e647a0901300217s73a6a295sa61232bac8c95115@mail.gmail.com>
	 <20090130113043.72fd0f55@gondolin>
Date: Fri, 30 Jan 2009 18:51:51 +0800
Message-ID: <d82e647a0901300251sf78f8dap9a319263f3f670f7@mail.gmail.com>
Subject: Re: [PATCH] driver core: remove polling for driver_probe_done(v2)
From: Ming Lei <tom.leiming@gmail.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: kay.sievers@vrfy.org, greg@kroah.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/30 Cornelia Huck <cornelia.huck@de.ibm.com>:
> On Fri, 30 Jan 2009 18:17:36 +0800,
> Ming Lei <tom.leiming@gmail.com> wrote:
>
>> If probing done does not mean the device is available, this patch should be
>> ignored or fixed further.
>>
>> But polling is really not good, is there a approach to avoid the polling for
>> appearence of the root device?
>
> I think the parts of your patch that replace polling for
> driver_probe_done() with waiting on the waitqueue are fine. The
> problematic part is the rootwait special case, where polling seems
> unavoidable afaics.

Yes.

Maybe we should keep the polling for root device. And I will resend a
patch ,which only replace the driver_probe_done().

Thanks.

>



-- 
Lei Ming
