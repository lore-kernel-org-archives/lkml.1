Return-Path: <linux-kernel-owner+w=401wt.eu-S1761185AbXEQXLp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761185AbXEQXLp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 19:11:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbXEQXLh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 19:11:37 -0400
Received: from mail.shareable.org ([81.29.64.88]:44611 "EHLO
	mail.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755746AbXEQXLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 19:11:35 -0400
Date: Thu, 17 May 2007 23:01:44 +0100
From: Jamie Lokier <jamie@shareable.org>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070517220144.GB10756@mail.shareable.org>
References: <20070515151919.GA32510@lazybastard.org> <200705171708.53038.arnd@arndb.de> <20070517202139.GD15676@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070517202139.GD15676@lazybastard.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
> > Almost all your static functions start with logfs_, why not this one?
> 
> Because after a while I discovered how silly it is to start every
> function with logfs_.  That prefix doesn't add much unless the function
> has global scope.  What I didn't do was remove the prefix from older
> functions.

It's handy when debugging or showing detailed backtraces.  Not that
I'm advocating it (or not), just something I've noticed in other
programs.

-- Jamie
