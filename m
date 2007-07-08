Return-Path: <linux-kernel-owner+w=401wt.eu-S1757559AbXGHTIQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757559AbXGHTIQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 15:08:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754894AbXGHTIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 15:08:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36957 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbXGHTID (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 15:08:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Sun, 8 Jul 2007 21:15:26 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pavel Machek <pavel@ucw.cz>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.44L0.0707072224270.10912-100000@netrider.rowland.org> <1183871661.3388.282.camel@localhost.localdomain>
In-Reply-To: <1183871661.3388.282.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707082115.27363.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 July 2007 07:14, Benjamin Herrenschmidt wrote:
[--snip--]
> 
> I just think that the freezer approach, as it is, is backward. We can't
> have a 3rd party try to discriminate what to freeze and what not, it
> will always get something wrong, and in some cases with the wrong timing
> or ordering.

Nice discussion, except for one thing: the freezer doesn't decide what to
freeze.  For example, even right now kernel threads decide if they want to be
frozen.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
