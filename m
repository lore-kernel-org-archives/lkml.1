Return-Path: <linux-kernel-owner+w=401wt.eu-S1759347AbXFQK5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbXFQK5Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 06:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757980AbXFQK5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 06:57:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:57498 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911AbXFQK5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 06:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:reply-to:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rWem4EqIoTK03OPKeMb+Ir/lQ0GOoa25vS8YHcRD6j13FiXpyaKKIVgnu86as4uNlm+QL0gpxYzcjIFVsmlCxKf+ImoAdT/IYrVIX6Kui4L0A0DaUbx8C1sekmh6kqmwTGw8D3hJgdJDpUs3n+A9wB5s+Xa0+MVCb7M08cTbKoo=
Subject: Re: USB remote control missing keycodes
From: Islam Amer <pharon@gmail.com>
Reply-To: pharon@gmail.com
To: Jiri Kosina <jikos@jikos.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706151249520.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD> <466D2DF7.9020709@aladin.ro>
	 <1181563063.19258.11.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
	 <1181743734.6163.1.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
	 <d120d5000706130817v5b9291d4h8653ade63882d2bc@mail.gmail.com>
	 <Pine.LNX.4.64.0706131741420.23280@twin.jikos.cz>
	 <1181750326.6163.6.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706131809530.23280@twin.jikos.cz>
	 <1181823597.6136.8.camel@iamer-laptop>
	 <Pine.LNX.4.64.0706141425180.23280@twin.jikos.cz>
	 <Pine.LNX.4.64.0706151211210.23280@twin.jikos.cz>
	 <Pine.LNX.4.64.0706151249520.23280@twin.jikos.cz>
Content-Type: text/plain
Date: Sun, 17 Jun 2007 13:57:00 +0300
Message-Id: <1182077820.5909.5.camel@iamer-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-15 at 12:51 +0200, Jiri Kosina wrote:
> On Fri, 15 Jun 2007, Jiri Kosina wrote:
> 
> > please try the patch below (against 2.6.22-rc4) and send me the result.
> 
> Now I see in the logs that there are also messages about the 
> report initialization failing, so we should also specify NOGET for this 
> device.
> 
> Could you please try the patch below instead, which does just that? 
> Thanks.

Sorry for the late reply, I don't have internet connection at home and I
had to download 2.6.22-rc5 to test.

Yes the last patch fixes everything, amazing! Thanks a lot for this :)
That's what I call opensource support...

Oh btw, Sorry about hijacking the other thread.

I noticed another button not working the "More" button. I think I
already got the idea of fixing these things, not that the "more" button
matters anyway but here's the output from this button for the sake of
completeness.

[  547.916065] drivers/hid/hid-core.c: report (size 5) (numbered)
[  547.916073] drivers/hid/hid-core.c: report 4 (size 4) =  f6 00 00 00
[  547.916081] hid-debug: input Consumer.0000 = 0
[  547.916088] hid-debug: input Consumer.00f6 = 1
[  547.924032] drivers/hid/hid-core.c: report (size 5) (numbered)
[  547.924036] drivers/hid/hid-core.c: report 6 (size 4) =  01 0f 00 00
[  547.924043] hid-debug: input ff80.0001 = 1
[  547.924052] hid-debug: input ff80.0001 = 15
[  547.924064] hid-debug: input ff80.0001 = 0
[  547.924069] hid-debug: input ff80.0001 = 0
[  548.035668] drivers/hid/hid-core.c: report (size 5) (numbered)
[  548.035673] drivers/hid/hid-core.c: report 4 (size 4) =  00 00 00 00
[  548.035679] hid-debug: input Consumer.00f6 = 0
[  548.035684] hid-debug: input Consumer.0000 = 1


