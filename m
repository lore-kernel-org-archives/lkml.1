Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbYAGOWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbYAGOWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 09:22:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753622AbYAGOWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 09:22:15 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:41395 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYAGOWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 09:22:14 -0500
Date: Mon, 7 Jan 2008 06:21:16 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: [patch 1/2] show being-loaded/being-unloaded indicator for
 modules
Message-ID: <20080107062116.0aa37438@laptopd505.fenrus.org>
In-Reply-To: <90564384@web.de>
References: <90564384@web.de>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jan 2008 11:09:23 +0100
devzero@web.de wrote:

> this looks very useful!
> 
> >Unfortunatly, it's not always easy to see directly
> >which module is being loaded/unloaded from the oops itself.
> 
> no wonder, as most modules seem to be very quiet on on load/unload.
> 


> 
> but i wonder if some mandatory "print a message on init/exit"
> wouldn`t give a benefit to admins or end-users, too. sure this would
> additionally clutter up syslog, but it would add transparency.

Regardless of the usefulness, really, if this would be mandatory for all modules, it should
be done in the module loader itself.... 
But I'm not entirely convinced how useful that is to do always, although I can see the 
point of having it as debug option, similar to the initcall debug stuff...


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
