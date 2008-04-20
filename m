Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbYDTTGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbYDTTGP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 15:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbYDTTGB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 15:06:01 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49802 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455AbYDTTGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 15:06:01 -0400
Date: Sun, 20 Apr 2008 21:06:31 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Stringify support commas
Message-ID: <20080420190631.GA6629@uranus.ravnborg.org>
References: <20080420183256.GA11350@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420183256.GA11350@Krystal>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 02:32:56PM -0400, Mathieu Desnoyers wrote:
> #define MYDEF a, b, c
> 
> __stringify(MYDEF) should be replaced by "a, b, c", but compilation fails
> because the __stringify macro expects only one argument. Fix it by using
> variable macro arguments in __stringify and __stringify_1.
> 
> Needed in my current NMI safe iret paravirt support work so I can expand
> a macro containing assembly code into a string.

This is a no-no for those archs that still use -traditional.
I dunno if this is a problem for you at the moment and the
right fix is anyway to nuke -traditional.

	Sam
