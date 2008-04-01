Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYDAKv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYDAKv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 06:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbYDAKvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 06:51:17 -0400
Received: from lazybastard.de ([212.112.238.170]:57565 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639AbYDAKvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 06:51:17 -0400
Date: Tue, 1 Apr 2008 12:51:04 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Artem Bityutskiy <dedekind@yandex.ru>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: UBIFS vs Logfs (was [RFC PATCH] UBIFS - new flash file system)
Message-ID: <20080401105104.GE7465@logfs.org>
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org> <47F1C78D.2050300@yandex.ru> <47F1CE9D.4080709@nokia.com> <20080401092548.GC7465@logfs.org> <47F202CD.4000804@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47F202CD.4000804@yandex.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 April 2008 12:39:25 +0300, Artem Bityutskiy wrote:
> 
> I'm not sure what you mean. In UBIFS we have lprops area, where we store
> per-LEB accounting. UBI lets it possible to have it on a fixed position.
> The accounting is a separate B-tree. Lprops area has its own independent
> garbage collector. You should probably refer the white paper for more
> information.

Fair enough.

The obvious downside of all this is depending on UBI, which has a linear
scan.  My goal was to avoid the linear scan completely.  It is a harder
goal and I haven't reached it yet.  Imo it is reachable and I will
continue going in that direction.

You picked the route of using UBI, which makes a lot of stuff easier.
It is a fair approach and I don't mind you taking it.  It has drawbacks,
but so has everything else.

Jörn

-- 
Anything that can go wrong, will.
-- Finagle's Law
