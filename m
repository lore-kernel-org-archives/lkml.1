Return-Path: <linux-kernel-owner+w=401wt.eu-S1764529AbZDAPEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764529AbZDAPEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 11:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761841AbZDAPEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 11:04:10 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:38346 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761587AbZDAPEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 11:04:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bMCZNuPy9MtSSBBLDiLNFlFU4RXmtY4PmSYGzn5S+c7vkYrwqAOpFXnGHzyNUBcefv
         HUvAPUTS7tzoH5JXLjWFr74P9bz1FWfUdbnaKgHrbbCgylXLdXTfK/BSPeCMc9lVQYsE
         FYlNeKN86OnXmkOJhgEepckQtw9i6byEVZGaM=
Date: Wed, 1 Apr 2009 19:05:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: hpa@zytor.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       xemul@openvz.org, yhlu.kernel@gmail.com
Subject: Re: [patch 6/6] x86: irqinit - merge irqinit_32/64.c into irqinit.c
Message-ID: <20090401150506.GA15781@localhost>
References: <20090329201545.470255691@openvz.org> <20090329202208.439338795@openvz.org> <20090401150101.GC6196@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090401150101.GC6196@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Apr 01, 2009 at 05:01:01PM +0200]
| 
| * Cyrill Gorcunov <gorcunov@openvz.org> wrote:
| 
| > So the files are merged there is still #include's
| > mess -- need serious cleanup.
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
| > ---
| >  arch/x86/kernel/Makefile     |    2 
| >  arch/x86/kernel/irqinit.c    |  249 +++++++++++++++++++++++++++++++++++++++++++
| >  arch/x86/kernel/irqinit_32.c |  246 ------------------------------------------
| >  arch/x86/kernel/irqinit_64.c |  249 -------------------------------------------
| >  4 files changed, 250 insertions(+), 496 deletions(-)
| 
| ok, this looks pretty well done.
| 
| If you could do the x86_quirk cleanup on top of this i guess we 
| could try it. (no need to redo the unification with the quirk thing, 
| that will break this patch.)
| 
| 	Ingo
| 

ok, will do the quirk cleanup on top of.

        Cyrill
