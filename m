Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbXHXPY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbXHXPY6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757502AbXHXPWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:22:35 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:59584 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbXHXPWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:22:33 -0400
Date: Fri, 24 Aug 2007 11:21:27 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Blaisorblade <blaisorblade@yahoo.it>
Cc: user-mode-linux-devel@lists.sourceforge.net,
       Satyam Sharma <satyam@infradead.org>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@osdl.org>, Joe Perches <joe@perches.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [uml-devel] [PATCH 6/6] UML - Fix hostfs style
Message-ID: <20070824152127.GA7190@c2.user-mode-linux.org>
References: <20070817194342.GA8759@c2.user-mode-linux.org> <alpine.LFD.0.999.0708181924020.29105@enigma.security.iitk.ac.in> <200708231655.00034.blaisorblade@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708231655.00034.blaisorblade@yahoo.it>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 04:54:59PM +0200, Blaisorblade wrote:
> > actually. Personally I'd prefer:
> >
> > 	else
> > 		type = OS_TYPE_DIR;
> 
> I strongly agree with this style; beyond style itself, one strong reason is 
> that joining statements hinder singlestepping through function code (it's 
> easy to run gdb on UML, and anyway kgdb exists).

How does that help?  gdb should stop as easily on a "else foo;" line as on 
	else
		foo;
right?

				Jeff

-- 
Work email - jdike at linux dot intel dot com
