Return-Path: <linux-kernel-owner+w=401wt.eu-S1752655AbZBQN7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbZBQN7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 08:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbZBQN7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 08:59:06 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:4454 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZBQN7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 08:59:06 -0500
Date: Tue, 17 Feb 2009 13:58:34 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       "Woodruff, Richard" <r-woodruff2@ti.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Kyle Moffett <kyle@moffetthome.net>, Oliver Neukum <oliver@neukum.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Arve Hj?nnev?g <arve@android.com>,
       Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       mark gross <mgross@linux.intel.com>, Uli Luckas <u.luckas@road.de>,
       Igor Stoppa <igor.stoppa@nokia.com>,
       Brian Swetland <swetland@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: [RFD] Automatic suspend
Message-ID: <20090217135833.GB25029@sirena.org.uk>
References: <f73f7ab80902161208h12837d4ex1d28d55d031d5d71@mail.gmail.com> <13B9B4C6EF24D648824FF11BE896716203771DD01B@dlee02.ent.ti.com> <20090216145948.6fea81c3@infradead.org> <200902170019.40599.rjw@sisk.pl> <20090216232329.GA15678@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216232329.GA15678@srcf.ucam.org>
X-Cookie: New systems generate new problems.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 11:23:30PM +0000, Matthew Garrett wrote:

> Arve said that the power state was equivalent in idle and suspend, but 
> that they preferred suspend because it stopped any periodic timers. I'd 
> be more interested in making sure that unnecessary timers aren't running 
> than focusing on automatically entering system-wide suspend - Nokia have 
> been managing this since 2005 with good results.

Definitely.  Even in the embedded case there is hardware which takes a
relatively long time to fully power down and resume without winning an
enormous amount on the power front (analogue stuff is a common culprit
here, it can take a noticable amount of time to bring it up cleanly).
