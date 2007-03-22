Return-Path: <linux-kernel-owner+w=401wt.eu-S933326AbXCVPp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326AbXCVPp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933367AbXCVPp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:45:57 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:45960 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933326AbXCVPp5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:45:57 -0400
Date: Thu, 22 Mar 2007 16:45:54 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
In-Reply-To: <46028BA8.5030906@ums.usu.ru>
Message-ID: <Pine.LNX.4.64.0703221642110.14457@scrub.home>
References: <45FD6EF5.1030706@ums.usu.ru> <Pine.LNX.4.64.0703221350400.14458@scrub.home>
 <46028303.7070104@ums.usu.ru> <Pine.LNX.4.64.0703221438050.14457@scrub.home>
 <46028BA8.5030906@ums.usu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 22 Mar 2007, Alexander E. Patrakov wrote:

> > hfs has a codepage option as well, but I don't know its default in the
> > various countries, but it could be different from DOS.
> 
> Yes. Since this comes from Mac world, it definitely makes sense to add
> CONFIG_MAC_CODEPAGE_DEFAULT, the corresponding module parameter, and make hfs
> (FIXME: anything else?) use this. However, I have no hfs filesystems, and thus
> can't test my changes.
> 
> Help from anyone who understands hfs code is welcome. In particular, what
> currently happens by default WRT the codepage? Where is the code responsible
> for this?

grep for nls_disk, the default simply does a direct mapping, so I don't 
really want to add another config option, but a module parameter would be 
useful.

bye, Roman
