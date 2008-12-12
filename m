Return-Path: <linux-kernel-owner+w=401wt.eu-S1759307AbYLLOC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759307AbYLLOC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 09:02:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758954AbYLLOB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 09:01:59 -0500
Received: from mx01.qsc.de ([213.148.129.14]:58043 "EHLO mx01.qsc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758924AbYLLOB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 09:01:58 -0500
Message-ID: <49426ECF.3070901@wizards.de>
Date: Fri, 12 Dec 2008 15:01:51 +0100
From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?= <holger@wizards.de>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: Nasty regression from .27.7 to .27.8: idle samba goes crazy
References: <pan.2008.12.08.06.18.57.357875@wizards.de> <200812080834.22924.rjw@sisk.pl> <pan.2008.12.08.08.07.29.439625@wizards.de> <493D4F5C.7020606@s5r6.in-berlin.de> <493D7349.10200@s5r6.in-berlin.de> <20081208222246.GA29232@sith.mimuw.edu.pl> <20081209123703.043067eb@dhcp-100-2-144.bos.redhat.com> <493FFE5E.2000404@colorfullife.com>
In-Reply-To: <493FFE5E.2000404@colorfullife.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Could you try the attached patch?
> It should fix the bug.

After applying Manfred's patch to .9-rc1, it *seems* that the problem is
gone. I have put the Windows client to sleep several times and after the
20-something minutes timeout smbd reports the error ("No route to host")
but does not go into a spinloop any more.
I'll continue to test this, but as far as I'm concerned this should go
into stable.9 as well (not sure if it's already in rc2).

thanks!
Holger
