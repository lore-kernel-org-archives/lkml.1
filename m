Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZK0WOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZK0WOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 17:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbZK0WOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 17:14:40 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50250 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbZK0WOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 17:14:39 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Patrick Mullaney <pmullaney@novell.com>
Subject: Re: [PATCH 3/3] macvlan: allow in-kernel modules to create and manage macvlan devices
Date: Fri, 27 Nov 2009 23:14:42 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: kaber@trash.net, netdev@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       bridge@lists.linux-foundation.org
References: <20091113195201.11184.25766.stgit@mimic.site> <20091113195529.11184.19011.stgit@mimic.site>
In-Reply-To: <20091113195529.11184.19011.stgit@mimic.site>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911272314.42641.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18f2vX3Z22v7Yq/sse4WQa0T2Rh+G1i8H5nczd
 HmdgJGDqreOBCFmDEOvCVfEKCvaX3BP9dbnFKW9dg5lDYYu/+E
 akjGOjDfSBngXXTHEqKQA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 November 2009, Patrick Mullaney wrote:
> 
> The macvlan driver didn't allow for creation/deletion of devices
> by other in-kernel modules. This patch provides common routines
> for both in-kernel and netlink based management. This patch
> also enables macvlan device support for gro for lower level
> devices that support gro.

I wonder if doing this way round is a good idea, why don't
you just use netlink to set up the endpoint device like
the current macvlan and macvtap do? I think doing it consistently
for all backends would be a significant advantage.

	Arnd <><
