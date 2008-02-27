Return-Path: <linux-kernel-owner+w=401wt.eu-S932870AbYB0AQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbYB0AQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 19:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756234AbYB0AQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 19:16:46 -0500
Received: from mail.gmx.net ([213.165.64.20]:59789 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756192AbYB0AQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:16:46 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+PKXl6uwWPxRPjjZfArdQNmyXKNswVDZW2KCGs7p
	drUYMMkdnJlyma
Date: Wed, 27 Feb 2008 01:16:48 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Krzysztof Halasa <khc@pm.waw.pl>, Randy Dunlap <randy.dunlap@oracle.com>,
       ricknu-0@student.ltu.se, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] CodingStyle: multiple updates
In-Reply-To: <Pine.LNX.4.64.0802270057310.15321@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0802270109440.5714@axis700.grange>
References: <1204062430.47c488def40a4@portal.student.luth.se>
 <20080226135444.f83a0536.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0802270033310.5714@axis700.grange> <m31w6zcm4l.fsf@maximus.localdomain>
 <Pine.LNX.4.64.0802270057310.15321@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Jan Engelhardt wrote:

> 
> On Feb 27 2008 00:51, Krzysztof Halasa wrote:
> >Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:
> >
> >> Now, I think, I am not the only one using emacs. Until now the "linux" 
> >> C-style fitted perfectly with the CodingStyle, now it no longer will. 
> >> Namely, emacs puts as many tabs to indent the continuation line as fit 
> >> (i.e., at tab width = 8 spaces it's just (extra indent / 8) tabs plus 
> >> (extra indent % 8) spaces. Is there a way to make emacs behave compatibly 
> >> to this proposal? If not, I would not like to have to re-indent every such 
> >> line manually or have my patches rejected because of this.
> >
> >Oh, I'm sure nobody will reject patches because of this now. It would
> >mean no patches are accepted.
> 
> Correct. Just did not want to even encourage any newcomers to use
> tabs when spacing is needed. Though, some editors unfortunately do
> just that - replacing 8 spaces by tabs on a new line when autoindent
> is on, like mcedit :-(

Then why do we define rules that we know that nobody will (be reasonably 
able to) adhere to?

I can see the reasoning behind using spaces instead of tabs in 
continuation lines and in in-line indentation like

	int x   = 1;
	void *c = NULL;

or

#define X  1
#define XY 2

although I personally perfer TABs there too. But as long as we do not want 
to actually impose that, I don't think we should define that.

Whereas an explicit rule requesting to use TABs and not spaces for 
different indentation levels seems good.

Thanks
Guennadi
---
Guennadi Liakhovetski
