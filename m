Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZKLSVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZKLSVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbZKLSVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:21:07 -0500
Received: from stinky.trash.net ([213.144.137.162]:63690 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZKLSVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:21:06 -0500
Message-ID: <4AFC5214.9030108@trash.net>
Date: Thu, 12 Nov 2009 19:21:08 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Patrick Mullaney <pmullaney@novell.com>
CC: linux-kernel@vger.kernel.org, arnd@arnd.de, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.rog
Subject: Re: [PATCH] netdevice: provide common routine for macvlan and vlan
 operstate management
References: <4AFAD86A.9070506@trash.net> <20091112180137.10186.9386.stgit@mimic.site>
In-Reply-To: <20091112180137.10186.9386.stgit@mimic.site>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patrick Mullaney wrote:
> This patch is intended to address your comment on moving the operstate
> transition function. I decided to move it to netdevice.h, perhaps that
> is a bad idea? It didn't seem to logically fall into dev.c or link_watch.c.
> I am not against moving them to either one though. Your other comments
> are addressed and I will send out a second series once this gets
> reviewed and agreed on.

Thanks. I don't mind much where exactly it is located, but I'd prefer
to not have it inlined. It doesn't seem terribly wrong to move it to
dev.c, there are even some helpers for stacked devices already, like
address list synchronization.

Besides that the patch looks fine to me.
