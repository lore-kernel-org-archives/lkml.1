Return-Path: <linux-kernel-owner+w=401wt.eu-S1761513AbYBAWk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761513AbYBAWk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 17:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762310AbYBAWki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 17:40:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:36229 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758560AbYBAWkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 17:40:35 -0500
Date: Fri, 1 Feb 2008 23:40:38 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux arch <linux-arch@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Are Section mismatches out of control?
Message-ID: <20080201224038.GC17828@uranus.ravnborg.org>
References: <20080201104718.GA11717@uranus.ravnborg.org> <20080201030329.9b760777.akpm@linux-foundation.org> <1201864894.23523.117.camel@brick> <Pine.LNX.4.64.0802012245250.18790@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802012245250.18790@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2008 at 10:47:25PM +0100, Jan Engelhardt wrote:
> 
> On Feb 1 2008 03:21, Harvey Harrison wrote:
> >> 
> >> Question is: why do people keep adding new ones when they are so easy to
> >> detect and fix?
> >> 
> >> Asnwer: because neither they nor their patch integrators are doing adequate
> >> compilation testing.
> >
> >[...]
> >Unless they break the build, or if there currently are 0 and they make
> >it non-zero, people seem not to care....sad.  Probably the same for
> >sparse/checkpatch, "there's plenty already, I can't be bothered to look"
> 
> checkpatch does not parse C, it uses heuristical regexes.
> 
> That makes it very different from sparse or the section mismatch
> finder which do not output false positives.

Unfortunately I most correct you. Section mismatch checks seldoms finds
what I would call 'real' bugs that causes oops - but it happen.
It is mostly fasle positives that needs workaround, but also a great
deal of missing annotation resulting in additional memory saved.
And then occasionally a bad reference in some error handling that
seldom trigger but when it does it would oops.

	Sam
