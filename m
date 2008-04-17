Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYDQILc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYDQILc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:11:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYDQILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:11:21 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:51098 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbYDQILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:11:19 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
Subject: Re: ehci-hcd affects hda speed
Date: Thu, 17 Apr 2008 10:20:11 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Rene Herman <rene.herman@keyaccess.nl>,
       Alessandro Suardi <alessandro.suardi@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803050036210.31935@nev.ubzr> <200804160738.13437.oliver@neukum.org> <alpine.LFD.1.10.0804170211220.8464@nev.ubzr>
In-Reply-To: <alpine.LFD.1.10.0804170211220.8464@nev.ubzr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804171020.14189.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 17. April 2008 00:23:08 schrieb Lev A. Melnikovsky:
> Oliver,
> 
> ON> EHCI should not scan an empty async. However this manufacturer
> ON> has shown a liberal attitude about conforming with specifications.
> ON> If the root hub is suspended, it can't do DMA. So it might help.
> Yes, it does, thank you. No DMA when suspended. Auto-suspend is executed 
> if external hub is the only attached device. Can this be used to block 
> spurious schedule traversal?

Obviously, yes, if only hubs are attached. The question is whether it
should be. It would be better to find a way to fix the chip bug in the active
state. However, as fixing all hardware bugs for that vendor may be difficult
I wanted to test whether a partial work around is available.

	Regards
		Oliver
