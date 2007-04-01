Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbXDAQ5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbXDAQ5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 12:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933660AbXDAQ5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 12:57:09 -0400
Received: from hosting4p.com ([81.0.235.160]:52308 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933652AbXDAQ5J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 12:57:09 -0400
Message-ID: <460FE478.9070901@slax.org>
Date: Sun, 01 Apr 2007 18:57:28 +0200
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: [patch] remove artificial software max_loop limit
References: <b040c32a0703300053u110063b0u80ee0e7b9dd158c2@mail.gmail.com>	<b040c32a0703300148w479cf4cdw667cf464edf7c725@mail.gmail.com>	<Pine.LNX.4.61.0703301105190.31834@yvahk01.tjqt.qr>	<b040c32a0703300225r3f8b1daah2f95e8af26c0d867@mail.gmail.com> <20070330141524.5f6cff29.akpm@linux-foundation.org> <460FE380.2050608@slax.org>
In-Reply-To: <460FE380.2050608@slax.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sorry I made a mistake,

there should be
> module parameter

instead of
 > boot parameter.

I am sorry.
The entire paragraph in my previous post should be the following:

I believe that IF you _really_ need to preserve the max_loop module 
parameter, then the parameter should _not_ be ignored, rather it should 
have the same function like before - to limit the loop driver so if you 
use max_loop=10 for example, it should not allow loop.c to create more 
than 10 loops.


Tomas M
slax.org
