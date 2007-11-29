Return-Path: <linux-kernel-owner+w=401wt.eu-S1762253AbXK2Axz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762253AbXK2Axz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:53:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbXK2Axs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:53:48 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:56468 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755709AbXK2Axr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:53:47 -0500
Date: Thu, 29 Nov 2007 01:53:46 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Greg KH <greg@kroah.com>
cc: Valdis.Kletnieks@vt.edu, Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ftp.linux.org.uk>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Out of tree module using LSM
In-Reply-To: <20071129003840.GA22530@kroah.com>
Message-ID: <Pine.LNX.4.64.0711290152470.22052@fbirervta.pbzchgretzou.qr>
References: <20071128144156.GA14106@infradead.org> <416908.77038.qm@web36613.mail.mud.yahoo.com>
 <20071128164613.GA21815@infradead.org> <25290.1196273705@turing-police.cc.vt.edu>
 <20071128183040.GW8181@ftp.linux.org.uk> <20071129003840.GA22530@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 28 2007 16:38, Greg KH wrote:
>> 
>> And if we are talking about the situation when files are written to
>> in controlled way (i.e. we are not concerned with malware running on
>> the box in question and just want to stop it from passing through
>> mailsewer, etc.), then there's no damn need to play with LSM - just
>> have e.g. coda with its commit-on-close and run the scanner on
>> commit.  End of story.  Mind you, in such setups one would be much
>> better off just having the mail server run the tests explicitly in
>> the userland, along with the rest of anti-spam, etc. filters.
>
>I've repeated the above statements so many times to a number of the
>anti-virus companies, and other people that really should know better,
>that I'm really sick of it.  For some reason, they keep trying to do
>things like this in the kernel, despite it being trivial to do in
>userspace properly.
>
Do you mean something along the lines of FUSE?


