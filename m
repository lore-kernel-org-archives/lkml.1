Return-Path: <linux-kernel-owner+w=401wt.eu-S1752152AbZFWA0B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbZFWA0B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 20:26:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbZFWAZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 20:25:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:34729 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754659AbZFWAZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 20:25:52 -0400
Subject: Re: [git pull] drm: previous pull req + 1.
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       Dave Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
       Andrew Lutomirski <luto@mit.edu>, dri-devel@lists.sf.net,
       Jerome Glisse <jglisse@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0906221121100.3240@localhost.localdomain>
References: <alpine.DEB.2.00.0906200619520.27130@skynet.skynet.ie>
	 <4A3DABE1.50309@mit.edu>
	 <alpine.DEB.2.00.0906210615450.6234@skynet.skynet.ie>
	 <alpine.LFD.2.01.0906210945170.3119@localhost.localdomain>
	 <alpine.LFD.2.01.0906210948340.3119@localhost.localdomain>
	 <cb0375e10906211150v7c54f355ga0066eccc128085@mail.gmail.com>
	 <alpine.LFD.2.01.0906211223190.3119@localhost.localdomain>
	 <alpine.DEB.2.00.0906212336200.20307@skynet.skynet.ie>
	 <4A3F3E3A.2030202@shipmail.org>
	 <alpine.LFD.2.01.0906221121100.3240@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 10:01:39 +1000
Message-Id: <1245715299.4017.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-22 at 11:22 -0700, Linus Torvalds wrote:
> Not going to happen.
> 
> Why? 'printk'.
> 
> If you can't handle printk, then you're basically useless. And printk 
> absolutely -has- to work in bad situations (the most important
> messages could happen in any context).

Well... yes and no. If X is frontmost, printk is not going to be
printed, ie, I'm talking about today, when the console is !KD_TEXT.

There -is- a mechanism to deal with these things today, and the console
semaphore does take care of accesses to the fb.

(That doesn't exclude having the ability to force-switch back to kernel
fb for printing things like oops btw, which KMS could do, but for basic
access control, it makes sense).

Cheers,
Ben.


