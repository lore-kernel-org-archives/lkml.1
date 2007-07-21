Return-Path: <linux-kernel-owner+w=401wt.eu-S1764196AbXGUTfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764196AbXGUTfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbXGUTez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:34:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58385 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbXGUTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:34:54 -0400
Date: Sat, 21 Jul 2007 21:34:53 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Alexander Shishkin <alexander.shishckin@gmail.com>
cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: from where comes "__moddi3"?
In-Reply-To: <71a0d6ff0707211233r52192d7aic98d2a307b044eca@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0707212134210.21737@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707211516480.6972@localhost.localdomain>
 <71a0d6ff0707211233r52192d7aic98d2a307b044eca@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 21 2007 23:33, Alexander Shishkin wrote:
> On 7/21/07, Robert P. J. Day <rpjday@mindspring.com> wrote:
>>
>>   again, probably displaying my abject ignorance, but i wrote a
>> trivial module that tries to "var % 15", and i get:
>>
>>   WARNING: "__moddi3" undefined!
> ...which comes from libgcc1 which you obviously don't want to link against.
>
> Does (var & 0x0f) not work for you?

v & 0x0F  <=>  v % 16



	Jan
-- 
