Return-Path: <linux-kernel-owner+w=401wt.eu-S1752453AbZK0Moa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbZK0Moa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 07:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbZK0Mo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 07:44:29 -0500
Received: from www84.your-server.de ([213.133.104.84]:49655 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZK0Mo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 07:44:29 -0500
Subject: Re: [PATCH] fix PPC floating point debug
From: Stefani Seibold <stefani@seibold.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <1259319716.2076.3.camel@pasglop>
References: <1259312340.9648.6.camel@wall-e>
	 <1259319716.2076.3.camel@pasglop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 27 Nov 2009 13:44:19 +0100
Message-ID: <1259325859.21806.7.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 27.11.2009, 22:01 +1100 schrieb Benjamin Herrenschmidt: 
> On Fri, 2009-11-27 at 09:59 +0100, Stefani Seibold wrote:
> > The PPC architecture is unable to debug applications using hardware
> > floating point, because it would not save the floating point registers.
> > 
> > After returning from the debugger, the contents of register was
> > modified. This patch fix this bug.
> 
> I'm not sure what problem you are trying to fix... debugging FP apps
> works just fine afaik. You don't need to flush the FP state into the
> thread when delivering the SIGTRAP. If you have a signal handler, that
> will be done for you by the signal code before laying out the signal
> frame. If you are using ptrace, you should be using the appropriate
> ptrace calls to retrieve the FP state and they should do the right thing
> to.
> 

Aeh... Forget it! Thank you for the support.

Stefani


