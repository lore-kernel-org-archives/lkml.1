Return-Path: <linux-kernel-owner+w=401wt.eu-S1757723AbYEEUo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757723AbYEEUo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 16:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753792AbYEEUoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 16:44:15 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:57223 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbYEEUoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 16:44:15 -0400
Date: Mon, 5 May 2008 22:44:49 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Subject: Re: How to link a .o with all modules
Message-ID: <20080505204449.GA9446@uranus.ravnborg.org>
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org> <20080504192434.GA23752@uranus.ravnborg.org> <D346E2E4-26C3-482E-ABBF-AF1EE97E91CD@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D346E2E4-26C3-482E-ABBF-AF1EE97E91CD@kernel.crashing.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >
> >Let me know if this does address your question.
> 
> The problem is MODPOST complains about undefined symbols:
> 
>   MODPOST 24 modules
> ERROR: "_restgpr_20_x" [net/key/af_key.ko] undefined!
> ERROR: "_restgpr_25_x" [net/key/af_key.ko] undefined!
> ERROR: "_restgpr_30_x" [net/key/af_key.ko] undefined!

I need a bit more context to try to analyse this.
Where did you expect _restgpr_20_x to be defined.
If in vmlinux then were they present in the
Module.symvers file?

If in the linked in .o file - could you
see the symbols using objdump.

etc.

Sorry - not much help right away.

PS. Travelling - do not expect responses until the
weekend.

	Sam
