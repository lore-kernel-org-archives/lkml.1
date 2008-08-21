Return-Path: <linux-kernel-owner+w=401wt.eu-S1755804AbYHUQH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbYHUQH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 12:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYHUQHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 12:07:16 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:64687 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYHUQHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 12:07:15 -0400
Date: Thu, 21 Aug 2008 08:59:48 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, jgarzik <jgarzik@pobox.com>
Cc: Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Marcin Slusarz <marcin.slusarz@gmail.com>,
       akpm@osdl.org
Subject: Re: [2.6.27-rc4] compilation warnings and section mismatches
Message-Id: <20080821085948.b19fb94b.randy.dunlap@oracle.com>
In-Reply-To: <20080821104307.346cbcb7@lxorguk.ukuu.org.uk>
References: <48AD2701.2000304@numericable.fr>
	<20080821104307.346cbcb7@lxorguk.ukuu.org.uk>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008 10:43:07 +0100 Alan Cox wrote:

> On Thu, 21 Aug 2008 10:27:45 +0200
> Rufus & Azrael <rufus-azrael@numericable.fr> wrote:
> 
> > Hi all,
> > 
> > Here are my compilation warnings and section mismatches when building 
> > the fresh rc4 kernel version.
> > 
> > Hope it could help you to fix.
> 
> All harmless
> 
> And patches to the skfp one have been posted repeatedly so I've no idea
> why they are still not in 2.6.27-rc - has Mr Garzik disappeared because
> some of the ATA ones are missing too like the LBA48 off by one fix ?

drivers/net/wd still has this problem also:  :(

wd.c:(.init.text+0x3cd8): undefined reference to `NS8390p_init'



---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
