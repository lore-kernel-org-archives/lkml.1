Return-Path: <linux-kernel-owner+w=401wt.eu-S1765465AbYDPWXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765465AbYDPWXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbYDPWXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:23:11 -0400
Received: from dell.benran.ru ([83.149.196.126]:44682 "EHLO ari.home"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753991AbYDPWXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:23:10 -0400
Date: Thu, 17 Apr 2008 02:23:08 +0400 (MSD)
From: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
To: Oliver Neukum <oliver@neukum.org>
cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ehci-hcd affects hda speed
In-Reply-To: <200804160738.13437.oliver@neukum.org>
Message-ID: <alpine.LFD.1.10.0804170211220.8464@nev.ubzr>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200804152202.18358.oliver@neukum.org> <alpine.LFD.1.10.0804160039420.4157@nev.ubzr> <200804160738.13437.oliver@neukum.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oliver,

ON> EHCI should not scan an empty async. However this manufacturer
ON> has shown a liberal attitude about conforming with specifications.
ON> If the root hub is suspended, it can't do DMA. So it might help.
Yes, it does, thank you. No DMA when suspended. Auto-suspend is executed 
if external hub is the only attached device. Can this be used to block 
spurious schedule traversal?

Thnks
-L
