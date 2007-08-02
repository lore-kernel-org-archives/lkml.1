Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbXHBNgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbXHBNgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:36:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752650AbXHBNf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:35:57 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54461 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbXHBNf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:35:57 -0400
Date: Thu, 2 Aug 2007 15:35:56 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Miklos Szeredi <miklos@szeredi.hu>
cc: adobriyan@gmail.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] type safe allocator
In-Reply-To: <E1IGaOE-0001a3-00@dorka.pomaz.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0708021534050.24572@fbirervta.pbzchgretzou.qr>
References: <E1IGAAI-0006K6-00@dorka.pomaz.szeredi.hu> 
 <E1IGYuK-0001Jj-00@dorka.pomaz.szeredi.hu> <b6fcc0a0708020504j7588061fq7e70a50499dcbdfe@mail.gmail.com>
 <Pine.LNX.4.64.0708021417400.24572@fbirervta.pbzchgretzou.qr>
 <E1IGaOE-0001a3-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 2 2007 15:06, Miklos Szeredi wrote:
>> On Aug 2 2007 16:04, Alexey Dobriyan wrote:
>> >On 8/2/07, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> >>   fooptr = kmalloc(sizeof(struct foo), ...);
>> >
>> >Key word is "traditional". Good traditional form which even half-competent
>> >C programmers immediately parse in retina.
>> 
>> And being aware of the potential type-unsafety makes programmers more
>> careful IMHO.
>
>That's a _really_ good reason ;)

Yes, a good reason not to use g_new(), so people do get bitten when
they are doingitwrong.



	Jan
-- 
