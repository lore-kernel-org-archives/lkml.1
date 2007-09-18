Return-Path: <linux-kernel-owner+w=401wt.eu-S1757122AbXIRGB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122AbXIRGB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 02:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753651AbXIRGBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 02:01:21 -0400
Received: from gw.goop.org ([64.81.55.164]:51982 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbXIRGBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 02:01:20 -0400
Message-ID: <46EF69B1.8020801@goop.org>
Date: Mon, 17 Sep 2007 23:01:21 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Muli Ben-Yehuda <muli@il.ibm.com>
CC: Borislav Petkov <bbpetkov@yahoo.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] unify DMA_..BIT_MASK definitions: v1
References: <20070918042919.GA8998@gollum.tnic> <20070918055803.GB4640@rhun.haifa.ibm.com>
In-Reply-To: <20070918055803.GB4640@rhun.haifa.ibm.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Muli Ben-Yehuda wrote:
>> +#define DMA_64BIT_MASK	DMA_BIT_MASK(64)
>>     
>
> This one does not do what you mean. You need an explicit mask or a
> ~0ULL here.

Yeah, I was just about to comment on it.  Its possible the compiler
might decide to shift by x%64 = 0.

    J

