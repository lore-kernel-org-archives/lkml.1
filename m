Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbYG2JBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbYG2JBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 05:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYG2JBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 05:01:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:56354 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752934AbYG2JBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 05:01:35 -0400
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Bastian Blank <waldi@debian.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080729080727.GA32595@wavehammer.waldi.eu.org>
References: <20080728185651.GA29530@wavehammer.waldi.eu.org>
	 <1217300778.11188.233.camel@pasglop>
	 <20080729073611.GA30627@wavehammer.waldi.eu.org>
	 <1217317404.11188.242.camel@pasglop>
	 <20080729080727.GA32595@wavehammer.waldi.eu.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 19:00:47 +1000
Message-Id: <1217322047.11188.244.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 10:07 +0200, Bastian Blank wrote:
> > Hrm... we do most of the console discovery from console_initcall for
> > legacy UARTs. see the code in legacy_serial.c, we just avoid doing
> > the add_preferred_console() thingy if there's a console= on the
> command
> > line :-)
> 
> The code did that, but the check was removed because it trips on
> netconsole=. See 5faae2e5d1f53df9dce482032c8486bc3a1feffc.

Argh. That's a mess. Well, legacy_serial still does that :-)

Ben.


