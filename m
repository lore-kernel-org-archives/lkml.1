Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYCJSDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYCJSDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 14:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbYCJSDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 14:03:24 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:48835 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbYCJSDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 14:03:23 -0400
Date: Mon, 10 Mar 2008 15:03:16 -0300
From: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [0/13] General DMA zone rework
Message-ID: <20080310150316.752e4489@mandriva.com.br>
In-Reply-To: <20080308004654.GQ7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org>
	<20080307175148.3a49d8d3@mandriva.com.br>
	<20080308004654.GQ7365@one.firstfloor.org>
Organization: Mandriva
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i586-mandriva-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 8 Mar 2008 01:46:54 +0100
Andi Kleen <andi@firstfloor.org> escreveu:

| >  I've tried to give them a try but got some problems. First, the
| > simple test case seems to fail miserably:
| 
| Hmm I guess you got a pretty filled up 16MB area already.
| Do you have a full log? It just couldn't allocate some memory
| for the 24bit mask, but that is likely because it just ran out of 
| memory.

 You'll find the full log here:

http://users.mandriva.com.br/~lcapitulino/tmp/minicom.cap

| I suppose it will work if you cut down the allocations in the 
| test case a bit, e.g. decrease NUMALLOC to 10 and perhaps MAX_LEN to
| 5*PAGE_SIZE. Did that in my copy.

[...]

| I put up an updated patchkit on ftp://firstfloor.org/pub/ak/mask/patches/
| It also has some other fixes.
| 
| Can you retest with that please?

 Yes, will do. But I have something to suggest.

 I saw that the patches you've posted here are only a subset of
the patches you have in your FTP. Should I test all the patches
you have or only the subset you posted?

 If you want to get only the subset tested, would be nice to
create a new directory in the FTP for them, that would make
my life easier a bit.

-- 
Luiz Fernando N. Capitulino
