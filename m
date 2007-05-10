Return-Path: <linux-kernel-owner+w=401wt.eu-S1760008AbXEJSiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760008AbXEJSiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 14:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756420AbXEJSiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 14:38:19 -0400
Received: from nikam-dmz.ms.mff.cuni.cz ([195.113.20.16]:42111 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753188AbXEJSiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 14:38:18 -0400
Date: Thu, 10 May 2007 20:38:16 +0200
From: Martin Mares <mj@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "Antonino A. Daplas" <adaplas@gmail.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@osdl.org>, Matt Domsch <Matt_Domsch@dell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>,
       James Bottomley <James.Bottomley@HansenPar.ms.mff.cuni.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@mailshack.com>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
Message-ID: <mj+md-20070510.183659.21639.nikam@ucw.cz>
References: <464158E9.2000207@zytor.com> <1178806235.18785.1189115515@webmail.messagingengine.com> <46435F8A.1040203@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46435F8A.1040203@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

> As far as I could tell, "scan" simply caused the nonstandard video
> driver scan modules (unsafe probes) to be invoked.  Since those modules
> are no longer present, there appeared to be no need for them.  The VGA
> and VESA probes are safe.

"scan" is still useful, because it is able to find BIOS video modes with
non-standard numbers (they are still sometimes found on recent cards).

				Have a nice fortnight
-- 
Martin `MJ' Mares                          <mj@ucw.cz>   http://mj.ucw.cz/
Faculty of Math and Physics, Charles University, Prague, Czech Rep., Earth
Entropy isn't what it used to be.
