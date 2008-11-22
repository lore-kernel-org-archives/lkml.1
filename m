Return-Path: <linux-kernel-owner+w=401wt.eu-S1756608AbYKVHMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608AbYKVHMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 02:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752738AbYKVHM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 02:12:27 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:33535 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYKVHM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 02:12:26 -0500
Message-ID: <4927B0D5.4020907@davidnewall.com>
Date: Sat, 22 Nov 2008 17:42:21 +1030
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Evgeniy Polyakov <zbr@ioremap.net>
CC: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [take 3] Use pid in inotify events.
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <cfec22b10811201434v2230d11dvc9797018e433fd20@mail.gmail.com> <20081120230612.GB6536@ioremap.net> <200811211939.46812.arnd@arndb.de>
In-Reply-To: <200811211939.46812.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2008, Evgeniy Polyakov wrote:
> I have a network server, which gets IO requests from different clients
> and maintains coherency of the data between them, but if file is
> modified locally I want to flush or invalidate remote data. I decided
> not to dig into the kernel on the server node and use inotify to get
> notifications about events, but there is no way to determine if given IO
> was originated by server itself (and in this case nothing should be
> done), or by external application which accesses exported directory (and
> in this case I should send update messages to clients).

Why not require local access to use the same mechanism as remote, i.e.
by "network mounting" the data on the local machine, too.  That way
there's no confusion over where the change originated nor who's copy
must be invalidated.

