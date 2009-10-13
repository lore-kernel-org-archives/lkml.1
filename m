Return-Path: <linux-kernel-owner+w=401wt.eu-S1761557AbZJMW26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557AbZJMW26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbZJMW26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:28:58 -0400
Received: from vena.lwn.net ([206.168.112.25]:53472 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbZJMW25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:28:57 -0400
Date: Tue, 13 Oct 2009 16:28:19 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: David Brownell <david-b@pacbell.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] GPIO: Add gpio_lookup
Message-ID: <20091013162819.02f53284@bike.lwn.net>
In-Reply-To: <200910131410.40305.david-b@pacbell.net>
References: <20091010134814.0bac8624@bike.lwn.net>
	<20091010135343.775e535f@bike.lwn.net>
	<200910131410.40305.david-b@pacbell.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Oct 2009 14:10:40 -0700
David Brownell <david-b@pacbell.net> wrote:

> Not real keen on this; see separate emails, and below.

OK, so the story I'm getting is that each driver needs to set up its
own mechanism for obtaining GPIO numbers - it needs to create its own
lookup mechanism.  That's fine, I can do that; I just thought it made
sense to make use of the information that's already there.

Andrew, you might as well drop the patch.

(I'm less worried about the uniqueness side, BTW; it just means drivers
need to create meaningful names for their GPIOs.)

Thanks,

jon
