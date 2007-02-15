Return-Path: <linux-kernel-owner+w=401wt.eu-S1423546AbXBPKOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423546AbXBPKOy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423554AbXBPKOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:14:54 -0500
Received: from smtp001.mail.ukl.yahoo.com ([217.12.11.32]:45652 "HELO
	smtp001.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1423546AbXBPKOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:14:53 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=QWT+cvlCr7/G0wy1ZFZBXUIrtDIcVjRa6TesCc8Et6Lgx906hlVBWs2zripl9memc8GIwgUWoUMfPt8u2YfZIBYiK/85bV15lIr65V/LBly862r0dxSl+brv3H81hLLZyElnnmniuDB9P/FPRKoG6S0GIhcYMO15zkrKwVonnB0=  ;
X-YMail-OSG: BxC6A1YVM1mEEYFu9h587VsKq4jSh.wQBC1qFFYMDWdqRcmJz1KBCM8iAM6uqu4LkhI7Us9Zlk6.KU7.RZhuhS0KiwizZ9.60qB9fKyR4CvwrKTgVxg1u40RtgiH.ijCfSMjrVCVu9NG
From: Blaisorblade <blaisorblade@yahoo.it>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: [uml-devel] x86_64: fix 2.6.18 regression - PTRACE_OLDSETOPTIONS should be accepted
Date: Thu, 15 Feb 2007 20:05:56 +0100
User-Agent: KMail/1.9.5
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <11715068631914-git-send-email-blaisorblade@yahoo.it> <20070214215123.57ef2d4a.akpm@linux-foundation.org> <20070215170154.GA5641@ccure.user-mode-linux.org>
In-Reply-To: <20070215170154.GA5641@ccure.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702152005.56594.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 February 2007 18:01, Jeff Dike wrote:
> On Wed, Feb 14, 2007 at 09:51:23PM -0800, Andrew Morton wrote:
> > Whatever happens, please ensure that the final fix makes it into -stable
> > as well.  Jeff's version of this patch wasn't cc'ed to stable@kernel.org.
>
> Paolo's patch was sent to -stable.  His should be used everywhere, and mine
> should be dropped.

Jeff, I verified my patch is _almost_ enough for 2.6.18 for fully booting a 
32bit UML; on 2.6.18 I had to also add PTRACE_GET/SET_THREAD_AREA (this fix 
was merged in 2.6.19) to avoid tons of TLS errors.

On 2.6.19, the crash at boot is removed (btw, that crash output no message - I 
hope that with your fatal/nonfatal/etc. introduction I would get a message) 
but another one happens when starting init. I'll test 2.6.20 ASAP.

Bye
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade

Chiacchiera con i tuoi amici in tempo reale! 
 http://it.yahoo.com/mail_it/foot/*http://it.messenger.yahoo.com 
