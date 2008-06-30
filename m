Return-Path: <linux-kernel-owner+w=401wt.eu-S1754774AbYF3N75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbYF3N75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbYF3N7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:59:47 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:40585 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbYF3N7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:59:46 -0400
Message-Id: <200806301359.m5UDxcjJ023252@cmf.nrl.navy.mil>
From: "Chas Williams (CONTRACTOR)" <chas@cmf.nrl.navy.mil>
To: David Woodhouse <dwmw2@infradead.org>
cc: netdev@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [Linux-ATM-General] [PATCH] firmware: convert Ambassador ATM driver to request_firmware()
In-reply-to: <1214832072.10393.342.camel@pmac.infradead.org>
Date: Mon, 30 Jun 2008 09:59:38 -0400
X-NRLCMF-Spam-Score: () hits=-0.02
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1214832072.10393.342.camel@pmac.infradead.org>,David Woodhouse writ
es:
>On Mon, 2008-06-30 at 09:15 -0400, Chas Williams (CONTRACTOR) wrote:
>> In message <1214831362.10393.340.camel@pmac.infradead.org>,David Woodhouse w
>rit
>> es:
>> >And wasn't it sba200e_ecd.bin ? 
>> 
>> oops.  sparc is big endian.  adding the const we have...
>
>You probably still want the ifdefs for MODULE_FIRMWARE().

i removed the #ifdef's from around MODULE_LICENSE().  there shouldnt
be any need for #ifdef's around MODULE_FIRMWARE() either.
