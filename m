Return-Path: <linux-kernel-owner+w=401wt.eu-S1755002AbXGGT2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002AbXGGT2T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 15:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbXGGT2K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 15:28:10 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753326AbXGGT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 15:28:08 -0400
Date: Sat, 7 Jul 2007 12:27:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
cc: Marcel Holtmann <marcel@holtmann.org>, Jiri Kosina <jkosina@suse.cz>,
       Dmitry Torokhov <dtor@insightbb.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Fix use-after-free oops in Bluetooth HID.
In-Reply-To: <1183834720.3066.83.camel@shinybook.infradead.org>
Message-ID: <alpine.LFD.0.999.0707071222480.31544@woody.linux-foundation.org>
References: <468A7D14.1050505@googlemail.com> 
 <d120d5000707051403r1d946375nb119ff86b26580ef@mail.gmail.com> 
 <Pine.LNX.4.64.0707070019110.11634@jikos.suse.cz>  <200707062033.18211.dtor@insightbb.com>
  <Pine.LNX.4.64.0707070257040.11634@jikos.suse.cz> 
 <1183771730.2789.1.camel@shinybook.infradead.org> 
 <1183775126.3066.5.camel@shinybook.infradead.org> 
 <1183832913.6351.130.camel@aeonflux.holtmann.net> 
 <alpine.LFD.0.999.0707071135090.31544@woody.linux-foundation.org>
 <1183834720.3066.83.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 7 Jul 2007, David Woodhouse wrote:
>
> When cleaning up HIDP sessions [...]

Thanks.

> Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Marcel Holtmann <marcel@holtmann.org>

Btw, and totally unrelated to the patch itself..

I changed that second "Signed-off-by:" into an "Acked-by:", since that 
more accurately reflects what happened.

Not that it really matters, but it's nice to see what chain the patch 
actually took (from you to me - sign-off path), and independently of that 
see who looked at it and approved it (acked-by), and then often we 
additionally end up having a set of people who might have tested it 
("Tested-by:") or maybe should just have been aware of it (the "Cc:") 
ones.

So the "Signed-off-by:" thing is one of many possible thigns that you can 
do, but it's somewhat special in that it has some "legal" meaning in that 
it is supposed to show the people who either wrote it or who forwarded it 
(possibly with changes, but quite often just unchanged).

			Linus
