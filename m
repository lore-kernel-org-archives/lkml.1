Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZHYLgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZHYLgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:36:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbZHYLgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:36:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38714 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576AbZHYLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:36:47 -0400
Date: Tue, 25 Aug 2009 13:36:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Allow the 'cut here' oops line to be displayed
	before calling BUG()
Message-ID: <20090825113640.GC1341@ucw.cz>
References: <20090820104956.29972.92662.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820104956.29972.92662.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-08-20 11:49:56, David Howells wrote:
> Allow the 'cut here' oops line to be displayed before calling BUG() as useful
> information is often displayed before BUG() is called.  Also use this to limit
> recursive oopsing.

Can we get rid of the stupid 'cut here' line, instead?

It does not carry real information, shouts, takes valuable
screen space...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
