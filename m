Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbYJMK13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbYJMK13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYJMK1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:27:16 -0400
Received: from rn-out-0910.google.com ([64.233.170.190]:43350 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755581AbYJMK1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=T/YKHKThYYfqmrcPaWO6Kuq8kLK3fN7WAzdNocOo5FkuiJ64cyTPePn1UuFR4phbmi
         CEzAFyuCmO6WqCej0kUJKFHIc5f6lpPFE8y8oQc52r+Xk0w82oNylGFC3UW5E0SCxznd
         TnjItDdh93ZYHhjYVJjxGhJiMvr5ypAUsB5L4=
Message-ID: <386072610810130327xf5ec9f1w33614e93beb69b13@mail.gmail.com>
Date: Mon, 13 Oct 2008 18:27:13 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Mike Frysinger" <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] netdev: DM9000: Added typecasting to supress some warnings on Blackfin
Cc: "Javier Herrero" <jherrero@hvsistemas.es>, jeff@garzik.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0810130324o17a2b98s6bb05670b814345d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223889009-31336-1-git-send-email-cooloney@kernel.org>
	 <20081013091725.GG31627@trinity.fluff.org>
	 <48F314B7.3020708@hvsistemas.es>
	 <386072610810130252s52c11423r69851740975ff517@mail.gmail.com>
	 <8bd0f97a0810130324o17a2b98s6bb05670b814345d@mail.gmail.com>
X-Google-Sender-Auth: 3784375404486266
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2008 at 6:24 PM, Mike Frysinger <vapier.adi@gmail.com> wrote:
> On Mon, Oct 13, 2008 at 05:52, Bryan Wu wrote:
>> On Mon, Oct 13, 2008 at 5:28 PM, Javier Herrero wrote:
>>> So it seems that we must correct that in other place?
>>
>> Yes, we need to check the I/O read_write functions.
>
> and drop the CONFIG_BLACKFIN hacks in the dm90000 driver ... we
> rewrite the write* functions to out* ... probably because we dont
> provide any write* functions in our headers
> -mike
>

No problem, I will take care of that.

-Bryan
