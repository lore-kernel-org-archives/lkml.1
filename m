Return-Path: <linux-kernel-owner+w=401wt.eu-S1752352AbYHKL5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbYHKL5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 07:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751204AbYHKL5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 07:57:37 -0400
Received: from mailtp.via.com.tw ([61.66.243.2]:34745 "EHLO mailtp.via.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbYHKL5h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 07:57:37 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer Device Driver
Date: Mon, 11 Aug 2008 19:57:34 +0800
Message-ID: <C80EF34A3D2E494DBAF9AC29C7AE4EB8078F49B8@exchtp03.taipei.via.com.tw>
In-Reply-To: <20080811091747.045A66D605@f09.poczta.interia.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer Device Driver
Thread-Index: Acj7kybH9AkDs6kFR5aMqSY4qWoRBAAFhMIg
From: <JosephChan@via.com.tw>
To: <krzysztof.h1@poczta.fm>
Cc: <linux-fbdev-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
       <akpm@linux-foundation.org>, <geert@linux-m68k.org>
X-OriginalArrivalTime: 11 Aug 2008 11:57:35.0635 (UTC) FILETIME=[71BD8630:01C8FBA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

Thanks. After re-checking again, I met the malformed issue.
I think that's my careless, I will re-submit the patch again later.

BRs,
Joseph

-----Original Message-----
From: krzysztof.h1@poczta.fm [mailto:krzysztof.h1@poczta.fm] 
Sent: Monday, August 11, 2008 5:18 PM
To: Joseph Chan; krzysztof.h1@poczta.fm
Cc: linux-fbdev-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org; akpm@linux-foundation.org; geert@linux-m68k.org
Subject: RE: [Linux-fbdev-devel] [PATCH 0/13 v2] viafb: VIA Frame Buffer Device Driver

> Hi Krzysztof,
> 
> Thanks to remind, but after I checked the patches in linux-fbdev-devel 
> mailing list.
> It seems there is no missing lines as you mentioned. 
> 

There are 3 lines missing at the end of each file. I assume they are empty one so no content is missing but the command:

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

