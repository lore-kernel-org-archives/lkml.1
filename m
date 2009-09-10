Return-Path: <linux-kernel-owner+w=401wt.eu-S1752839AbZIJQmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbZIJQmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 12:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZIJQma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 12:42:30 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:52591 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbZIJQma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 12:42:30 -0400
Date: Thu, 10 Sep 2009 18:42:32 +0200
From: Andreas Mohr <andi@lisas.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc6 (yeah, I know...): weird tty / X.org state currently
Message-ID: <20090910164232.GA27404@rhlx01.hs-esslingen.de>
References: <20090910103126.GA17742@rhlx01.hs-esslingen.de> <20090910165837.50544526EC9@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910165837.50544526EC9@mailhub.coreip.homeip.net>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Sep 10, 2009 at 09:25:00AM -0700, Dmitry Torokhov wrote:
> On Thursday 10 September 2009 03:31:26 am Andreas Mohr wrote:
> > Possibly the kernel's control key state got stuck in a weird state,
> > perhaps due to some input layer race conditions or so.
> >
> > Or is it X.org's input handling which is responsible for Ctrl-Alt-F1
> > etc. combos? I wouldn't think so...
> 
> X is solely responsible for handling input when active. It switches
> console in RAW mode which bypasses kernel processing) and does it's
> own thing. This includes switching VTs upon Ctrl-ALt-Fx.

OK, but what's puzzling is that there's no indication whatsoever that
there's any broken Ctrl activity (neither in konsole nor in a tty),
yet the tty gets switched readily as soon as only Alt-Fx gets pressed in
X.org. 

IOW (unless that's wrong) you're saying that it's X.org which has
a broken Ctrl key state (but solely when doing the Alt-Fx switch,
_not_ when doing Ctrl-L or regular letter input), not the kernel.

If so, would this problem warrant notifying X.org upstream,
or is it likely to be fixed in newer X.org releases?

Andreas Mohr
