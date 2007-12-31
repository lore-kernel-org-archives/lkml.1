Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbXLaTG3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbXLaTG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:06:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXLaTGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:06:20 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:59714 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244AbXLaTGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:06:19 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: [PATCH] Force UNIX domain sockets to be built in
Date: Mon, 31 Dec 2007 20:05:16 +0100
User-Agent: KMail/1.9.6
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Adrian Bunk" <bunk@kernel.org>,
       "Bodo Eggert" <7eggert@gmx.de>,
       "Jan Engelhardt" <jengelh@computergmbh.de>, devzero@web.de,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <alpine.LSU.0.999.0712311300020.3686@be1.lrz> <200712311818.12825.mb@bu3sch.de> <64bb37e0712311037w42bae43ayb3c10b2e0310586d@mail.gmail.com>
In-Reply-To: <64bb37e0712311037w42bae43ayb3c10b2e0310586d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712312005.17384.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 December 2007 19:37:43 Torsten Kaiser wrote:
> The base problem is that there already are many options to break
> external modules. (CONFIG_MODULES=n ;) )

Exactly. There already are enough ways to break external modules.
No need to introduce more. ;)

> The question I can't answer in this context is: Do distributions want
> to support external modules?
> Only if yes, your argument is valid. But then they could just disable
> this feature and prevent this kind of bugreports.

That's my point. Nobody will risk bugs to save a few bytes of memory.

-- 
Greetings Michael.
