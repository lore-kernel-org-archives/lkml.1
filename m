Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZAZUag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZAZUag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZAZUaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:30:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60258
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753507AbZAZUaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:30:23 -0500
Date: Mon, 26 Jan 2009 12:30:25 -0800 (PST)
Message-Id: <20090126.123025.79139510.davem@davemloft.net>
To: khc@pm.waw.pl
Cc: jaswinder@kernel.org, shemminger@vyatta.com, sam@ravnborg.org,
       jaswinderlinux@gmail.com, arnd@arndb.de, mingo@elte.hu,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: why usr/include/linux/if_frad.h is required
From: David Miller <davem@davemloft.net>
In-Reply-To: <m3ljt0pvmg.fsf@intrepid.localdomain>
References: <20090121.153712.84781438.davem@davemloft.net>
	<1232803533.17900.4.camel@localhost.localdomain>
	<m3ljt0pvmg.fsf@intrepid.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n0QKUiwM013002

From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 24 Jan 2009 16:32:55 +0100

> Jaswinder Singh Rajput <jaswinder@kernel.org> writes:
> 
> > After killing CONFIG_DLCI and CONFIG_DLCI_MODULE, it is also killing the
> > kernel:
> >
> >   CC      net/socket.o
> > In file included from net/socket.c:75:
> > include/linux/if_frad.h:170: error: â€˜CONFIG_DLCI_MAXâ€™ undeclared here (not in a function)
> 
> Perhaps this would do (untested).
> Signed-off-by: Krzysztof HaÅ‚asa <khc@pm.waw.pl>

This looks good, applied, thanks everyone.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
