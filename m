Return-Path: <linux-kernel-owner+w=401wt.eu-S1760308AbXGTNWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760308AbXGTNWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 09:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754822AbXGTNWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 09:22:44 -0400
Received: from baros.cubic.ch ([213.239.213.98]:48712 "EHLO baros.cubic.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbXGTNWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 09:22:43 -0400
X-Greylist: delayed 1710 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jul 2007 09:22:43 EDT
Message-ID: <46A0B06B.3060701@cubic.ch>
Date: Fri, 20 Jul 2007 14:54:03 +0200
From: Tim Tassonis <timtas@cubic.ch>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Krzysztof Halasa <khc@pm.waw.pl>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, ak@suse.de, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
Subject: Re: [git patches] two warning fixes
References: <20070718235504.GA9601@havoc.gtf.org> <alpine.LFD.0.999.0707181834070.27353@woody.linux-foundation.org> <m3vecgbjix.fsf@maximus.localdomain> <alpine.LFD.0.999.0707191056010.27353@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707191056010.27353@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> 
> I think "must_check" is an abomination. It makes the callee dictate what 
> the caller has to do, but dammit, if the callee really "knows" its errors 
> are that serious, it should damn well handle them itself.
> 
> The whole "sysfs_create_file()" thing is an example of that. If it fails, 
> it fails. The caller can't do anythign about it anyway, except perhaps 
> print a message.  Why the hell does such a function have the "right" to 
> dictate what the user should do?

Well, that's just how OO fascists think. An object dictates to the user 
what he/she can do with it, as opposed to the user can do what he 
wants/needs.


Tim
