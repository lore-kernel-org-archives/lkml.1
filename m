Return-Path: <linux-kernel-owner+w=401wt.eu-S1752182AbXCLTGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182AbXCLTGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 15:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752190AbXCLTGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 15:06:51 -0400
Received: from smtp19.orange.fr ([80.12.242.19]:12095 "EHLO smtp19.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182AbXCLTGu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 15:06:50 -0400
X-ME-UUID: 20070312190649716.117781C00081@mwinf1921.orange.fr
Subject: Re: [PATCH][RSDL-mm 0/7] RSDL cpu scheduler for 2.6.21-rc3-mm2
From: Xavier Bestel <xavier.bestel@free.fr>
To: Con Kolivas <kernel@kolivas.org>
Cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       ck list <ck@vds.kolivas.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <200703130549.47058.kernel@kolivas.org>
References: <200703111457.17624.kernel@kolivas.org>
	 <200703122223.07048.kernel@kolivas.org>
	 <1173710082.6326.49.camel@Homer.simpson.net>
	 <200703130549.47058.kernel@kolivas.org>
Content-Type: text/plain; charset=ISO-8859-15
Date: Mon, 12 Mar 2007 20:06:43 +0100
Message-Id: <1173726403.9153.5.camel@bip.parateam.prv>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 13 mars 2007 à 05:49 +1100, Con Kolivas a écrit :
> Again I think your test is not a valid testcase. Why use two threads for your 
> encoding with one cpu? Is that what other dedicated desktop OSs would do?

One thought occured to me (shit happens, sometimes): as your scheduler
is "strictly fair", won't that enable trivial DoS by just letting an
user fork a multitude of CPU-intensive processes ?

	Xav


