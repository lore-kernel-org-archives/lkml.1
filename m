Return-Path: <linux-kernel-owner+w=401wt.eu-S1757942AbYJ3TC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbYJ3TC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbYJ3TCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:02:51 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:44021 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773AbYJ3TCv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:02:51 -0400
Date: Thu, 30 Oct 2008 20:02:48 +0100
Message-Id: <489164141@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: how much license information inside the kernel ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/YkpF/gaG0fI0ReTEbORXOMZFTV5stiC3QMo7YUL0zxWJji
 6bnvXGrYLXXBCwQcFE2tCB7j3lr9u21Y6nPW9KCMrAJVXVdkig=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> devzero@web.de wrote:
> > hi,
> > 
> > i found that there is a LOT of repeating licensing information in the
> > kernel.
> > 
> > for me,
> > 
> > find ./linux-2.6.27 -type f -exec cat {} \; |egrep "free software|GNU
> > General Public License|Free Software Foundation|version 2 of the
> > License|distributed in the hope|WITHOUT ANY WARRANTY|FITNESS FOR A
> > PARTICULAR"
> > 
> > gives a file sized ~3.5M
> > 
> > That`s more than 1% of the kernel source.
> > 
> > What about the idea to shorten that licening information to a minimum
> > , e.g. by shrinking that to a single, catchy line ,  linking to a
> > special licensing file like COPYING or linking to the FSF website ?
> > 
> > please no flames, i know this idea could be pure dynamite for some
> > people - but i thought 3.5M is worth this mail.
> > 
> > regards roland
> > 
> > ps: i`m not sure if that has been discussed already, but i didn`t
> > find that in the archive. please ignore, otherwise.
> 
> It may be 3.5 MB uncompressed, but disk space is cheap, and repeated 
> strings compress extremely well to save bandwidth.  If you work with the 
> kernel source enough for this to be an issue, you should use git. 
> You'll download these license headers once, and never again unless the 
> copyright info gets changed by a patch.  From a technical perspective, 
> the problem isn't nearly as bad as it looks, and it keeps the lawyers 
> happy, so it's really not worth messing with.  There's plenty of 
> lower-hanging fruit in unifying drivers for similar hardware, unifying 
> 32-bit and 64-bit architectures, and other things that make the code 
> more maintainable.
> 
> -- Chris
> 

yes, convinced - it´s not worth the work to clean that up.
________________________________________________________________________
Schon gehört? Bei WEB.DE gibt' s viele kostenlose Spiele:
http://games.entertainment.web.de/de/entertainment/games/free/index.html

