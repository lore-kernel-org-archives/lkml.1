Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbZEKNF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbZEKNF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 09:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZEKNFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 09:05:50 -0400
Received: from casper.infradead.org ([85.118.1.10]:59596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbZEKNFt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 09:05:49 -0400
Date: Mon, 11 May 2009 06:05:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Fabio Comolli <fabio.comolli@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] devtmpfs
Message-ID: <20090511060528.31e0f20c@infradead.org>
In-Reply-To: <ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
References: <20090509143742.GA27663@kroah.com>
	<20090510152005.GA9461@suse.de>
	<1241980263.9562.380.camel@laptop>
	<20090510221901.30c1c5a5@lxorguk.ukuu.org.uk>
	<ac3eb2510905101647k12a1b9ck71d43933037bac48@mail.gmail.com>
	<20090510170016.1e3a4d97@infradead.org>
	<ac3eb2510905101822t7fde14b3nf2c689621f69c925@mail.gmail.com>
	<m1pregmkld.fsf@fess.ebiederm.org>
	<ac3eb2510905110346p115dc8bbscc8921c9bd7e500d@mail.gmail.com>
	<20090511115504.568c9a92@lxorguk.ukuu.org.uk>
	<ac3eb2510905110434nb123423m134e848c17c3c736@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 13:34:52 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:
> 
> > - That the other proposals are worse than yours.
> 
> I also did, in exactly this thread.

no you have not. But I'd like you to ;)

You have not commented substantially on my counter proposal to make the
single file with the "device list" (eg char/block, major, minor, name)
so that userland can make the nodes in 0.01-or-less seconds, but
with the permissions/owners it wants and the tmpfs mount options it
wants.

Again this makes for a more flexible solution (not flexible in "if you
don't like it don't use it" sense but flexible in the "there's multiple
uses and ways to use it" sense) while keeping the benefits of what you
want to achieve. 

Eric has shown that making the nodes itself and mounting the tmpfs is
basically free, but that the cost (0.05 seconds) was in groveling
through sysfs. Fixing that.. I'm all for it. 

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
