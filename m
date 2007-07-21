Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbXGUV0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbXGUV0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 17:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760669AbXGUV0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 17:26:15 -0400
Received: from khc.piap.pl ([195.187.100.11]:39304 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761559AbXGUV0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 17:26:14 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       jidong xiao <jidong.xiao@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: what does select statement mean in Kconfig file?
References: <4104961b0707210634gea4e240x11b043b4e64c7840@mail.gmail.com>
	<Pine.LNX.4.64.0707210938190.22394@localhost.localdomain>
	<46A2397C.4050100@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 21 Jul 2007 23:26:12 +0200
In-Reply-To: <46A2397C.4050100@s5r6.in-berlin.de> (Stefan Richter's message of "Sat, 21 Jul 2007 18:51:08 +0200")
Message-ID: <m3lkd95tzf.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> The latter is sometimes hard or impossible to satisfy.  Therefore the
> select statement should be used with care, i.e. only for library-type
> helper code which itself shouldn't depend on further options.

How about depending on common dependency?

Something like

config A
	bool XXX
	depends on ARM

config B
	depends on ARM
	select A


or:

if ARM
	config A
		bool XXX
endif

if ARM
	config B
		select A
endif
-- 
Krzysztof Halasa
