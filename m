Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbZFJCNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbZFJCNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 22:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZFJCNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 22:13:31 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64854 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbZFJCNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 22:13:30 -0400
Date: Tue, 9 Jun 2009 19:13:25 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: "harald.dunkel@t-online.de" <harald.dunkel@t-online.de>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: how to stop kernel nfsd?
In-Reply-To: <1MDcTI-1elcES0@fwd00.aul.t-online.de>
Message-ID: <alpine.DEB.2.01.0906091907340.6439@bogon>
References: <1MDcTI-1elcES0@fwd00.aul.t-online.de>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/YHi12rtMtjDLGe4ez1Mzsej4lJF0Byoz0Cnr
 8iNyQ1coEq0sGzbymrkhp/S+idUHJR0yFs1ApRiwwXGOdF9mX9
 GHbap9lG+YoHWP7sV7+SA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, harald.dunkel@t-online.de wrote:
> Which signal would be correct to gracefully kill the kernel nfs daemons?

What are you trying to achieve? "killing", "terminating" or "graceful 
reloading", as in "re-exporting the shares", which can be done with 
exportfs(8).

> Debian's runlevel script (just for example) tries SIGINT, but this
> doesn't work, as it seems.

Which version of Debian? 5.0 over here just terminates the processes to 
stop nfs-kernel-server.

Christian.
-- 
BOFH excuse #438:

sticky bit has come loose
