Return-Path: <linux-kernel-owner+w=401wt.eu-S1761539AbYD2NAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761539AbYD2NAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 09:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760738AbYD2NAL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 09:00:11 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760090AbYD2NAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 09:00:09 -0400
Date: Sun, 27 Apr 2008 22:50:20 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Mika Fischer <mika.fischer@zoopnet.de>
Cc: Ingo Molnar <mingo@elte.hu>, yhlu.kernel@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Gabriel C <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
   layout v2
Message-ID: <20080427225020.1aa4c5a6@linux.intel.com>
In-Reply-To: <4815ED15.3080702@zoopnet.de>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804280206.52641.yhlu.kernel@gmail.com>
	<20080428130826.GH27997@elte.hu>
	<20080428064925.318659b9@laptopd505.fenrus.org>
	<4815ED15.3080702@zoopnet.de>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 17:28:21 +0200
Mika Fischer <mika.fischer@zoopnet.de> wrote:

> Arjan van de Ven schrieb:
> > yep one should not touch existing MTRRs. If you run out, tough luck.
> > Thats what we have PAT for.
> > Changing them anyway is a deathtrap with various things,
> > suspend/resume being only one of the nasty cases.
> 
> Hm. I currently have to remove the offending (i.e. overlapping my
> video memory) MTRRs and split them so that they have a hole where my
> video memory is.

I'm not arguing that it sometimes works. It's just a big trap to default enable ;(


> 
> Ah, so the new X will be able to use the video memory in
> write-combining mode even if I have an MTRR saying this area is
> uncachable or write-back?

yes.
When it gets released...
