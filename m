Return-Path: <linux-kernel-owner+w=401wt.eu-S1752852AbZI0TDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbZI0TDm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 15:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZI0TDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 15:03:41 -0400
Received: from fifo99.com ([67.223.236.141]:37293 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbZI0TDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 15:03:41 -0400
Subject: Re: [PATCH] WARN_ONCE(): use bool for condition
From: Daniel Walker <dwalker@fifo99.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
In-Reply-To: <4ABFB524.5030008@cesarb.net>
References: <4ABFAB27.1040608@cesarb.net>
	 <1254075912-17557-1-git-send-email-cesarb@cesarb.net>
	 <1254076108.20648.529.camel@desktop>  <4ABFB524.5030008@cesarb.net>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 12:03:06 -0700
Message-Id: <1254078186.20648.531.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 15:55 -0300, Cesar Eduardo Barros wrote:
> Daniel Walker escreveu:
> > On Sun, 2009-09-27 at 15:25 -0300, Cesar Eduardo Barros wrote:
> >> -               int __ret_warn_on = !!(condition);                      \
> >> +               bool __ret_warn_on = (condition);                       \
> > 
> > Did you try it without removing the "!!" ? In my original email I tested
> > the path of least resistance, and I left the "!!" in there..
> 
> Just tried, same result (it seems gcc can easily see past the double 
> negation).

Ok, I'm not sure it's worth it then.. I'd prefer to move forward and
assume newer compilers, but most kernel hackers use older compilers ..
It's a pretty big size increase too..

Daniel

