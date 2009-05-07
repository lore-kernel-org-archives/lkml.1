Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbZEGUkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbZEGUkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761256AbZEGUkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:40:04 -0400
Received: from mail.crca.org.au ([67.207.131.56]:37355 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259AbZEGUkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:40:01 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] [RFC] TuxOnIce
From: Nigel Cunningham <nigel@tuxonice.net>
Reply-To: nigel@tuxonice.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Fabio Comolli <fabio.comolli@gmail.com>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org,
       tuxonice-devel@lists.tuxonice.net
In-Reply-To: <200905072127.11995.rjw@sisk.pl>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
	 <200905072022.15202.rjw@sisk.pl>
	 <b637ec0b0905071157x2d6f050aqcb825241c51ccb84@mail.gmail.com>
	 <200905072127.11995.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 08 May 2009 06:41:00 +1000
Message-Id: <1241728860.19600.207.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Thu, 2009-05-07 at 21:27 +0200, Rafael J. Wysocki wrote:
> In fact I agree, but there's a catch.  The way in which TuxOnIce operates LRU
> pages is based on some assumptions that may or may not be satisfied in future,
> so if we decide to merge it, then we'll have to make sure these assumptions
> will be satisfied.  That in turn is going to require quite some discussion I
> guess.

Agreed. That's why I've got that GEMS patch - it's putting pages on the
LRU that don't satisfy the former assumptions: they are used during
hibernating and need to be atomically copied. If there are further
developments in that area, I would hope we could just extend what's been
done with GEMS.

Regards,

Nigel

