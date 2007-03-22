Return-Path: <linux-kernel-owner+w=401wt.eu-S932465AbXCVNtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbXCVNtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 09:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932478AbXCVNtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 09:49:32 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:45643 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465AbXCVNtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 09:49:31 -0400
Date: Thu, 22 Mar 2007 14:49:26 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       agalakhov@ifmlrs.uran.ru, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] Sanitize filesystem NLS handling
In-Reply-To: <46028303.7070104@ums.usu.ru>
Message-ID: <Pine.LNX.4.64.0703221438050.14457@scrub.home>
References: <45FD6EF5.1030706@ums.usu.ru> <Pine.LNX.4.64.0703221350400.14458@scrub.home>
 <46028303.7070104@ums.usu.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 22 Mar 2007, Alexander E. Patrakov wrote:

> It is exposed as a mount parameter and kernel configuration option only for
> fat and smbfs (the two filesystems that my patch touches for this matter), and
> both of these filesystems come from DOS days, where there was one codepage for
> a given country. So, for me, it made sense to glue these two parameters,
> because they both should be set to this codepage. The contrary would (AFAIK)
> only make sense if one gets floppies from France, but communicates with Polish
> SMB servers. It is a very rare situation, isn't it? Or do you know any other
> example where it would clearly make sense to have different defaults for fat
> and smbfs?

hfs has a codepage option as well, but I don't know its default in the 
various countries, but it could be different from DOS.

bye, Roman
