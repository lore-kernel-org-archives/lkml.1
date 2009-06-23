Return-Path: <linux-kernel-owner+w=401wt.eu-S1757995AbZFWC0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757995AbZFWC0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 22:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFWC0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 22:26:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:59536 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZFWC0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 22:26:45 -0400
Subject: Re: [git pull] drm: previous pull req + 1.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090622190712.4c0ace71@jbarnes-g45>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	 <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	 <4A3F3E3A.2030202@shipmail.org> <1245715213.4017.13.camel@pasglop>
	 <alpine.LFD.2.01.0906221721450.3240@localhost.localdomain>
	 <1245719079.4017.25.camel@pasglop> <20090622181832.771dac03@jbarnes-g45>
	 <1245722325.4017.29.camel@pasglop>  <20090622190712.4c0ace71@jbarnes-g45>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 12:26:15 +1000
Message-Id: <1245723975.4017.33.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 19:07 -0700, Jesse Barnes wrote:

> Yeah I don't think we should try to change the mode, unless we really
> have to for whatever reason.  fbcon should generally be able to paint
> to whatever we have up as long as we set it up properly.

Well... it may not. IE. The text consoles can be using a different mode
than X, and so fbcon will be all setup for that ... (including how many
lines/columns etc...).

So it's not totally trivial... but on the other hands, it would be
useful to avoid as much as possible complicated things like mode
switches when hitting an oops.

Cheers,
Ben.

