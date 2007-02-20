Return-Path: <linux-kernel-owner+w=401wt.eu-S965084AbXBTPkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbXBTPkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965090AbXBTPkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:40:06 -0500
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:49125
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965084AbXBTPkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:40:04 -0500
Message-ID: <45DB1646.4040909@microgate.com>
Date: Tue, 20 Feb 2007 09:39:50 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 1.5.0.8 (Windows/20061025)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Mockern@yandex.ru, alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: how to limit flip buffer size in tty driver?
References: <45DAB02A.000001.11699@soapbox.yandex.ru>	 <20070220125329.55fb7210@localhost.localdomain>	 <45DAEE93.000001.01672@webmail16.yandex.ru> <1171976314.3531.125.camel@laptopd505.fenrus.org>
In-Reply-To: <1171976314.3531.125.camel@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> On Tue, 2007-02-20 at 15:50 +0300, Mockern wrote:
>> Thank you Alan for your respond,
>>
>> Could you help me with a problem which I have with my tty driver, please?
> 
> 
> I suspect Alan would be able to help you a whole lot better if you
> actually included the full source code of your driver...

Not to mention responding to the previous advice
of others (including myself and Theodore) who stated
there is no magic function in a driver that
directly supports the user mode cat program, and that
he should look at the tty settings controllable by stty.
(in particular clocal)

I also suggested running cat on a standard serial port
and getting that working first. Then applying those stty
settings to his custom device/driver.

(Background: he says other user mode programs work
to read/write but that cat < /dev/foocustom does nothing.)

-- 
Paul Fulghum
Microgate Systems, Ltd.
