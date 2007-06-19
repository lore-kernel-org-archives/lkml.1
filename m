Return-Path: <linux-kernel-owner+w=401wt.eu-S1755233AbXFSVpP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbXFSVpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbXFSVpC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:45:02 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54635 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751319AbXFSVpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:45:00 -0400
Date: Tue, 19 Jun 2007 22:50:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Chris Snook <csnook@redhat.com>, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
Message-ID: <20070619225021.225d4c7e@the-village.bc.nu>
In-Reply-To: <467829C4.5020101@zytor.com>
References: <46731169.2090002@hawkeye.stone.uk.eu.org>
	<4673182B.4090800@redhat.com>
	<46739E89.1080003@hawkeye.stone.uk.eu.org>
	<46781A5B.9090104@redhat.com>
	<467829C4.5020101@zytor.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 12:08:52 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Chris Snook wrote:
> > I pointed out NetApp's .snapshot directories because that's a method
> > that uses legal path character, but doesn't break anything.  With this
> > method, userspace tools will have to be taught that : is suddenly a
> > special character.
> 
> Not to mention that the character historically used for this purpose is
> ; (semicolon.)

Yes but tdskb:foo.mac[1013,1013,frob];4 is *not* elegant. POSIX is very
clear about what is acceptable as magic in a pathname, and the unix spec
even more so.  The NetApp approach recognizes two important things

1.	Old version access is the oddity not the norm
2.	Standards behaviour is important


Alan
