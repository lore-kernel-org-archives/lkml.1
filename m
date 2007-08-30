Return-Path: <linux-kernel-owner+w=401wt.eu-S1762703AbXH3QqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762703AbXH3QqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 12:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705AbXH3QqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 12:46:15 -0400
Received: from 85-10-209-111.clients.your-server.de ([85.10.209.111]:55508
	"EHLO mail.road.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759607AbXH3QqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 12:46:14 -0400
From: Uli Luckas <u.luckas@road.de>
Organization: Road GmbH
To: "Xu Yang" <risingsunxy@googlemail.com>
Subject: Re: parse_tag_ramdisk
Date: Thu, 30 Aug 2007 18:46:08 +0200
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <ab40e9c0708300707r2e6d2d71y42940084db5038ac@mail.gmail.com> <200708301806.42905.u.luckas@road.de> <ab40e9c0708300910m3cba4c7bie3f6c9d471a155ff@mail.gmail.com>
In-Reply-To: <ab40e9c0708300910m3cba4c7bie3f6c9d471a155ff@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708301846.09669.u.luckas@road.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 30. August 2007, Xu Yang wrote:
> Hi Uli,
>
>
> thanks for your reply.
>
> just have a question, where is the tag list, how can i modify this?
>
If you don't know where the list is created, how do you now that it contains a 
ramdisk tag? There is a chance, that the kernel does not even get a ram disk 
tag at all. This would also explain, why it is not parsed ;-)

The tag list is supplied by your bootloader. How the bootloader creates the 
list and how to change the order depends on your bootloader. You probably 
have to read (and patch) it's source code.

regards,
Uli

-- 

------- ROAD ...the handyPC Company - - -  ) ) )

Uli Luckas
Software Development

ROAD GmbH
Bennigsenstr. 14 | 12159 Berlin | Germany
fon: +49 (30) 230069 - 64 | fax: +49 (30) 230069 - 69
url: www.road.de

Amtsgericht Charlottenburg: HRB 96688 B
Managing directors: Hans-Peter Constien, Hubertus von Streit
