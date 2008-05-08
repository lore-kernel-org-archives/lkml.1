Return-Path: <linux-kernel-owner+w=401wt.eu-S1763685AbYEHOme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763685AbYEHOme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYEHOmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:42:25 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:57046 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117AbYEHOmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:42:24 -0400
Message-ID: <48231104.30606@s5r6.in-berlin.de>
Date: Thu, 08 May 2008 16:41:08 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Gene Heskett <gene.heskett@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Linux 2.6.26-rc1, build bails out fairly early
References: <200805080918.39908.gene.heskett@gmail.com>
In-Reply-To: <200805080918.39908.gene.heskett@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene Heskett wrote:
> Build bails out:
>   LD      drivers/built-in.o
> ld: drivers/media/built-in.o: No such file: No such file or directory
> make[1]: *** [drivers/built-in.o] Error 1
> make: *** [drivers] Error 2

Looks like this will help:
Subject: [patch, -git] drivers/media build fix for modular builds
Date: Wed, 30 Apr 2008 09:48:07 +0200
From: Ingo Molnar <mingo@elte.hu>
http://marc.info/?t=120954180500005
-- 
Stefan Richter
-=====-==--- -=-= -=---
http://arcgraph.de/sr/
