Return-Path: <linux-kernel-owner+w=401wt.eu-S1764498AbYHEUbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764498AbYHEUbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763128AbYHEUan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:30:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39094 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755796AbYHEUam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:30:42 -0400
Date: Tue, 5 Aug 2008 21:12:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Eric Paris <eparis@redhat.com>, "Press, Jonathan" <Jonathan.Press@ca.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org
Subject: Re: [malware-list] [RFC 0/5] [TALPA] Intro to a linux
 interfaceforon access scanning
Message-ID: <20080805211243.382a878b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080805110221.57e4b46c@infradead.org>
References: <1217883616.27684.19.camel@localhost.localdomain>
	<20080804223249.GA10517@kroah.com>
	<1217896374.27684.53.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807431@USILMS12.ca.com>
	<1217948212.27684.120.camel@localhost.localdomain>
	<2629CC4E1D22A64593B02C43E855530304807436@USILMS12.ca.com>
	<1217956796.11547.12.camel@paris.rdu.redhat.com>
	<20080805103840.1aaa64a5@infradead.org>
	<20080805182944.262f20d7@lxorguk.ukuu.org.uk>
	<20080805110221.57e4b46c@infradead.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Scripts
> 
> get either opened or exec'd...
> 
> (ignoring stdin-fed scripts right now.. but that's a problem regardless)

Don't forget pty/tty pairs, ioctls to type chars etc

> > Attempts to screen content
> 
> can you explain?

One common use for scanning is to scan content not looking for executable
stuff but for things like malformed image files and the like. It's also
useful for indexing and in those cases you don't really want ld.so in the
way.

> > Exec occuring after ld.so is compromised
> 
> this is post-compromise scenario; if you have enough root rights to do
> that then it's game over.

You still want to know if you spot this. And the root rights thing
assumes no selinux. For a large case of uses I would agree however.

Alan
