Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab0BCRrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:47:42 -0500
Received: from www84.your-server.de ([213.133.104.84]:57335 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932746Ab0BCRrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:47:39 -0500
Subject: Merge of the enhanced reimplemention of the kfifo API
From: Stefani Seibold <stefani@seibold.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>,
       Roger Quadros <quadros.roger@gmail.com>,
       "Ira W. Snyder" <iws@ovro.caltech.edu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Shargorodsky Atal <ext-atal.shargorodsky@nokia.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 03 Feb 2010 18:46:58 +0100
Message-ID: <1265219218.22285.21.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

-rc6 is out and i ask for merging the new macro based kfifo
reimplementation into linux-next and/or 2.6.34. I got a lot of positive
feedback but currently no ACK.

The reimplementation is 100% compatible to the previous one but more
flexibel and highly optimized. The code is tested and works fine.

I am sorry about the size of the patch, but there is no way to split it
down into separate patches because it is a complete different approach
and a full replacement of the kfifo.c and kfifo.h files. 

You can access the latest posting at
http://patchwork.kernel.org/patch/75443/

If i get an okay, i will fix the current users of the kfifo from using
byte stream fifo to the desired data type. Maybe with the help of
Greg ;-)

I hate to write code for the trash bin, so please give it a try.

Greetings,
Stefani

BTW: Zack Brown wrote a positive statement in the German Linux magazine.


