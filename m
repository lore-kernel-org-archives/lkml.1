Return-Path: <linux-kernel-owner+w=401wt.eu-S939184AbXFHSnm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939184AbXFHSnm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:43:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937330AbXFHSne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:43:34 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:5068 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966199AbXFHSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:43:32 -0400
Date: Fri, 8 Jun 2007 20:43:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Adrian Bunk <bunk@stusta.de>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jesper Juhl <jesper.juhl@gmail.com>,
       jcm@jonmasters.org, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] update checkpatch.pl to version 0.03
In-Reply-To: <20070608163911.GA3569@stusta.de>
Message-ID: <Pine.LNX.4.64.0706082041570.3570@fbirervta.pbzchgretzou.qr>
References: <20070607232248.332edee8@the-village.bc.nu> <20070607232152.GU5500@stusta.de>
 <20070608004117.57868755@the-village.bc.nu> <20070608000455.GW5500@stusta.de>
 <20070608115219.694c642d@the-village.bc.nu> <20070608123942.GZ5500@stusta.de>
 <9a8748490706080734h6ce5959fq6e7cb802d9a555cc@mail.gmail.com>
 <20070608144230.GA5500@stusta.de> <Pine.LNX.4.64.0706081710380.10769@fbirervta.pbzchgretzou.qr>
 <20070608164236.4ba7acae@the-village.bc.nu> <20070608163911.GA3569@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 8 2007 18:39, Adrian Bunk wrote:
>> > >>> Does the console handle it correctly during boot?
>> 
>> Yes

That's most likely because printk() handles neither special chars nor
special fun (like ANSI color and movement codes). Hence, we should be
safe should there be spurious utf8 output on the console (which is
most likely 8-bit before userspace switches it to utf-8).

>I'm simply saying that allowing UTF-8 in MODULE_AUTHOR and printk's as 
>you want to can have unwanted effects.
>
>And I gave modinfo as an example for a tool that is not yet able to 
>handle UTF-8 correctly in all cases.
>
>In my opinion, it's not worth the hassle to allow UTF-8 there.
>Feel free to disagree.
>
>> > So, we had some ISO8859-1 and some UTF-8 in there already. (And as for 
>> > MODULE_AUTHOR, it should stay there - 'fix' modinfo instead.)

(Well, and convert all the MODULE_AUTHORs to utf-8)

>> 
>> Using UTF-8 not 8859-1 for consistency is sensible, especially as 8859-1
>> is obsolete and effectively useless now (although I guess much of the
>> '8859-1' in the kernel is 1:1 with 8859-15, which isn't so obsolete but
>> is just as useless)
>
>Agreed, if we allow a non-ASCII charset, it should be UTF-8.




	Jan
-- 
