Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZFJAiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZFJAiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 20:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbZFJAiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 20:38:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60260
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456AbZFJAiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 20:38:05 -0400
Date: Tue, 09 Jun 2009 17:38:06 -0700 (PDT)
Message-Id: <20090609.173806.193714555.davem@davemloft.net>
To: wg@grandegger.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: net tree build warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A2E603E.3040603@grandegger.com>
References: <4A2E46A7.6020302@grandegger.com>
	<20090609.042625.194310688.davem@davemloft.net>
	<4A2E603E.3040603@grandegger.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Grandegger <wg@grandegger.com>
Date: Tue, 09 Jun 2009 15:14:38 +0200

> David Miller wrote:
>> From: Wolfgang Grandegger <wg@grandegger.com>
>> Date: Tue, 09 Jun 2009 13:25:27 +0200
>> 
>>> [PATCH] can: sja1000_of_platform: fix build problems with printk format
>>>
>>> Variables of type size_t should be printed with the format "%zx".
>>>
>>> Signed-off-by: Wolfgang Grandegger <wg@grandegger.com>
>> 
>> It's not a "size_t", it's a "resource_size_t" which can be
>> "unsigned long long" on some platforms.
> 
> Right, but I assume that the %zx handles that type properly as well.

It absolutely does not.

resource_size_t is a arch specifically defined type that
could be anything, it does not conform to the definitions
of size_t.
