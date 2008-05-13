Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbYEMOU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbYEMOU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755715AbYEMOUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:20:20 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:59576 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYEMOUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:sender;
        b=E157kikq/d0Qjf6Jetr2CpF0czAC/J7kDqompsyp4dQosVXB9lzvRVjo1rSmby9w6OtNcv04DkkUg/nSvC9bw2ARjL9UtJxBtFIX+oEp0fGELScJwZJSeft6QSTd8bQCpryFnzrutUh6/SdtGQKVqwVM6don7uPzAP4HyVjwAaA=
Message-ID: <4829A39F.7050308@laptop.org>
Date: Tue, 13 May 2008 10:20:15 -0400
From: "Richard A. Smith" <richard@laptop.org>
Reply-To: richard@laptop.org
Organization: One Laptop per Child
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andres Salomon <dilinger@queued.net>
CC: avorontsov@ru.mvista.com, Andrew Morton <akpm@linux-foundation.org>,
       cbou@mail.ru, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: [PATCH] power_supply: add CHARGE_COUNTER property and olpc_battery
 support for it
References: <20080508003454.722ba511@ephemeral>	<20080508105145.GA32017@polina.dev.rtsoft.ru>	<20080508130102.3218f1e9@ephemeral>	<20080508171320.GA8226@polina.dev.rtsoft.ru>	<48234C25.4040807@laptop.org>	<20080508193614.GA31188@polina.dev.rtsoft.ru>	<4823663B.6060409@laptop.org> <20080512214629.443a5999@ephemeral>
In-Reply-To: <20080512214629.443a5999@ephemeral>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andres Salomon wrote:

> +		ec_word = be16_to_cpu(ec_word);
> +		val->intval = ec_word * 4167 / 10;

Whats wrong with:

 > +		val->intval = ((int)ec_word) * 6250 / 15;

Which does not have overflow problems and keeps more precision.

-- 
Richard Smith  <richard@laptop.org>
One Laptop Per Child
