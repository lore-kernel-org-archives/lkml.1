Return-Path: <linux-kernel-owner+w=401wt.eu-S1752588AbYCJKMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbYCJKMS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 06:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbYCJKMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 06:12:05 -0400
Received: from dell.benran.ru ([83.149.196.126]:53295 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750940AbYCJKME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 06:12:04 -0400
Date: Mon, 10 Mar 2008 13:11:53 +0300 (MSK)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: David Brownell <david-b@pacbell.net>
cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
       Rene Herman <rene.herman@keyaccess.nl>, linux-kernel@vger.kernel.org
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <alpine.LFD.1.00.0803062244010.10693@nev.ubzr>
Message-ID: <alpine.LFD.1.00.0803101303240.4772@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <47CEC816.6000808@keyaccess.nl> <5a4c581d0803051203s1a0048c2u5f10b3eb442cfafb@mail.gmail.com> <200803051303.46275.david-b@pacbell.net> <alpine.LFD.1.00.0803062244010.10693@nev.ubzr>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

...meanwhile, I have tried to change (as suggested in another thread) the 
timeout value in the following line:

(void)handshake(ehci, &ehci->regs->status, STS_ASS, 0, 1500);

Makes no difference. Neither introducing additional delays to provide 
safety margins at several other loci helped a bit. Any idea what to try 
next?

Also, does anyone have a VT6212L datasheet? Unfortunately, Google haven't 
found it for me.

Thanks
-L
