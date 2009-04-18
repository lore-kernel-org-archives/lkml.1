Return-Path: <linux-kernel-owner+w=401wt.eu-S1751053AbZDRIlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053AbZDRIlt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752951AbZDRIlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:41:40 -0400
Received: from mail.it-technology.at ([62.99.145.147]:39378 "EHLO
	mail.it-technology.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826AbZDRIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:41:40 -0400
Message-ID: <0d3ceee0bebd3c68fb0d568239117425.squirrel@webmail.it-technology.at>
In-Reply-To: <200904180938.48276.oliver@neukum.org>
References: <2c05d20b7e24c4bf9cbfba19b9891f70.squirrel@webmail.it-technology.at>
    <200904171641.33546.oliver@neukum.org>
    <8472e581ef388a89b5ee8a7ed8dd1fdc.squirrel@webmail.it-technology.at>
    <200904180938.48276.oliver@neukum.org>
Date: Sat, 18 Apr 2009 10:41:37 +0200 (CEST)
Subject: Re: [PATCH] usb driver for intellon based PLC like devolo dlan duo
From: "Peter Holik" <peter@holik.at>
To: "Oliver Neukum" <oliver@neukum.org>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Am Samstag 18 April 2009 09:16:28 schrieb Peter Holik:
>
>> > +       len = (skb->data[skb->len - 2] | (skb->data[skb->len - 1] << 8));
>> >
>> > Please use a conversion function.
>>
>> do you mean
>>
>> len = le16_to_cpu(skb->data[skb->len - 2] | (skb->data[skb->len - 1] <<
>> 8));
>
> Without the "|". Just dereference the pointer.

this way?

len = le16_to_cpu(*(__le16 *)&skb->data[skb->len - 2]);

cu Peter


