Return-Path: <linux-kernel-owner+w=401wt.eu-S933449AbXCaCsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449AbXCaCsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 22:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933458AbXCaCsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 22:48:33 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:10756 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933449AbXCaCsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 22:48:32 -0400
Subject: Re: [PATCH 9/9] clocksource: refactor duplicate registration
	checking
From: Daniel Walker <dwalker@mvista.com>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       johnstul@us.ibm.com
In-Reply-To: <Line.LNX.4.64.0703302158380.29742@d.namei>
References: <20070330184541.583153763@mvista.com>
	 <20070330184616.429016225@mvista.com>
	 <Line.LNX.4.64.0703302158380.29742@d.namei>
Content-Type: text/plain
Date: Fri, 30 Mar 2007 19:47:52 -0700
Message-Id: <1175309273.12252.184.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-03-30 at 21:59 -0400, James Morris wrote:
> On Fri, 30 Mar 2007, Daniel Walker wrote:
> 
> >  /**
> >   * clocksource_register - Used to install new clocksources
> >   * @t:		clocksource to be registered
> >   *
> > - * Returns -EBUSY if registration fails, zero otherwise.
> > + * Always returns zero.
> >   */
> >  int clocksource_register(struct clocksource *c)
> 
> Return should be void, then.

Yeah, that's another patch tho ..

Daniel

