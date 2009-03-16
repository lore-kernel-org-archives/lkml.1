Return-Path: <linux-kernel-owner+w=401wt.eu-S1761035AbZCPOUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761035AbZCPOUh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 10:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZCPOU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 10:20:28 -0400
Received: from gw.goop.org ([64.81.55.164]:38371 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754054AbZCPOU1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 10:20:27 -0400
Message-ID: <49BE6027.60805@goop.org>
Date: Mon, 16 Mar 2009 07:20:23 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: bderzhavets@yahoo.com
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: tip.git regression from "vsprintf: unify the
 format decoding layer for its 3 users"
References: <50370.4113.qm@web56105.mail.re3.yahoo.com>
In-Reply-To: <50370.4113.qm@web56105.mail.re3.yahoo.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boris Derzhavets wrote:
> What is the issue status in meantime ?
> git pull reports conflicting merge ./lib/vsprintf.c
> PV DomUs  may be brought up , but cannot be
> shutdown.
>

Do a "git checkout xen/dom0/hackery; git reset --hard 
remotes/xen/xen/dom0/hackery" to rebase your local hackery branch to the 
upstream one.  I did a bit of a history-rewrite to replace the reverts 
with the proper fix.

    J
