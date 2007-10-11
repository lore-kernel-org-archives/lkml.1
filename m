Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbXJKAF6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbXJKAF6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 20:05:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755806AbXJKAFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 20:05:51 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:35539 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291AbXJKAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 20:05:50 -0400
Message-ID: <470D68DA.2010803@davidnewall.com>
Date: Thu, 11 Oct 2007 09:35:46 +0930
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Valdis.Kletnieks@vt.edu
CC: Gustavo Chain <g@0xff.cl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reserve N process to root
References: <20071009194820.6c8d6e8d@0xff.cl> <470C2FA7.5030207@davidnewall.com> <20071010011523.7d6cca12@0xff.cl> <470C66A6.2060801@davidnewall.com>            <20071010094622.7b8121cf@0xff.cl> <27658.1192045814@turing-police.cc.vt.edu>
In-Reply-To: <27658.1192045814@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> What David meant was that "root will always have a slot" doesn't *actually*
> help unless you *also* have a way to actually *spawn* such a process.  In order
> to do the ps, kill, and so on that you need to recover, you need to already
> have either a root shell available, or a way to *get* a root shell that doesn't
> rely on a non-root process (so /bin/su doesn't help here).

That's right, although it's worse than that.  You need to have a process 
with CAP_SYS_ADMIN.  If root processes normally have that capability 
then the reserved slots may well disappear before you notice a problem.  
If root processes normally don't have it, then you need to guarantee 
that one is already running.
