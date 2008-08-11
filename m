Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbYHKJSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbYHKJSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:18:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYHKJRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:17:54 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:6263 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYHKJRy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:17:54 -0400
Date: 11 Aug 2008 11:17:46 +0200
From: krzysztof.h1@poczta.fm
Subject: RE: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer Device Driver
To: "JosephChan@via.com.tw" <JosephChan@via.com.tw>,
       "krzysztof.h1@poczta.fm" <krzysztof.h1@poczta.fm>
Cc: "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "geert@linux-m68k.org" <geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: TEXT/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-ORIGINATE-IP: 83.17.101.58
X-Mailer: PSE
Message-Id: <20080811091747.045A66D605@f09.poczta.interia.pl>
X-EMID: c5240acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Krzysztof,
> 
> Thanks to remind, but after I checked the patches in linux-fbdev-devel
> mailing list.
> It seems there is no missing lines as you mentioned. 
> 

There are 3 lines missing at the end of each file. I assume they are empty one
so no content is missing but the command:

patch -p1 < viafb3.patch

ends with:
patch: **** malformed patch at line 259: diff -Nurp a/drivers/video/via/accel.h b/drivers/video/via/accel.h

If one adds three lines "+" at the line 259, the patch command ends with:

patching file drivers/video/via/accel.h
patch: **** malformed patch at line 446:

Adding three lines "+" at the mentioned file solves the problem.

Kind regards,
Krzysztof

----------------------------------------------------------------------
Taniej na zagraniczne komorki!
Sprawdz >>> http://link.interia.pl/f1ece

