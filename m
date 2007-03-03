Return-Path: <linux-kernel-owner+w=401wt.eu-S2992816AbXCCAwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992816AbXCCAwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 19:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992817AbXCCAwd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 19:52:33 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3199 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992816AbXCCAwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 19:52:32 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Mar 2007 16:52:29 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Nicholas Miell <nmiell@comcast.net>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
In-Reply-To: <1172871820.2999.22.camel@entropy>
Message-ID: <Pine.LNX.4.64.0703021615140.2381@alien.or.mcafeemobile.com>
References: <20070301133018.GB30177@2ka.mipt.ru>  <200703011519.20001.dada1@cosmosbay.com>
 <20070301141637.GA20006@elte.hu>  <20070301145454.GB12684@2ka.mipt.ru>
 <20070301150942.GA26025@elte.hu>  <20070301153655.GB8217@2ka.mipt.ru>
 <20070302105713.GB15576@elte.hu>  <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com>
  <20070302193941.GB8450@elte.hu>  <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com>
  <20070302202931.GA5101@elte.hu>  <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com>
 <1172871820.2999.22.camel@entropy>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Mar 2007, Nicholas Miell wrote:

> The point Ingo was making is that the x86 ABI already requires the FPU
> context to be saved before *all* function calls.

I've not seen that among Ingo's points, but yeah some status is caller 
saved. But, aren't things like status word and control bits callee saved? 
If that's the case, it might require proper handling.



- Davide


