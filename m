Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbZDXSkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbZDXSkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 14:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbZDXSkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 14:40:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38935 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752352AbZDXSka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 14:40:30 -0400
Date: Fri, 24 Apr 2009 11:37:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
       mchan@broadcom.com, davem@davemloft.net
Subject: Re: [BUG] 2.6.30-rc3: bnx2 failing to load firmware
In-Reply-To: <200904242031.52793.elendil@planet.nl>
Message-ID: <alpine.LFD.2.00.0904241135570.3101@localhost.localdomain>
References: <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <alpine.LFD.2.00.0904212014170.3101@localhost.localdomain> <20090424175238.GA19646@csn.ul.ie> <200904242031.52793.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Apr 2009, Frans Pop wrote:
>
> Looks like you're using an initramfs initrd and the bnx2 module is getting 
> loaded at that stage. Have you checked that the bnx firmware file is 
> included in your initramfs?

According to his config he has:

	CONFIG_FIRMWARE_IN_KERNEL=y

which should make all initrd issues pointless - the firmware should be 
included in the kernel directly.

		Linus
