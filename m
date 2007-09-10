Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbXIJWlJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbXIJWlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 18:41:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933016AbXIJWk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 18:40:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49829 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933011AbXIJWk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 18:40:56 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [RFC] kbuild - introduce vdir to make life easier for x86_64
Date: Tue, 11 Sep 2007 00:40:41 +0200
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       kbuild devel <kbuild-devel@lists.sourceforge.net>
References: <20070910191138.GA31541@uranus.ravnborg.org>
In-Reply-To: <20070910191138.GA31541@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709110040.41605.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> The below are the minimal clean-up - a bit more could be done.
> 
> Comments?

Looks good in principle. My only suggestion would be to name it something
differently than vdir. I know that's what GNU make calls it, but it's still
pretty cryptic. How about just fallback-dir ? 

Also what would be nice (I don't know if it's doable in make) would
be a separate variable (e.g. other-obj-... := ) that contains the fallback
names and that is double checked against the fallback directory. That
would document it clearly what's going on. Failing that stuffing 
them into a comment would be good at least.

-Andi

