Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbXFSWI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbXFSWI2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 18:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbXFSWIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 18:08:18 -0400
Received: from terminus.zytor.com ([192.83.249.54]:47910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415AbXFSWIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 18:08:17 -0400
Message-ID: <467853BB.1090109@zytor.com>
Date: Tue, 19 Jun 2007 15:07:55 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Chris Snook <csnook@redhat.com>, Jack Stone <jack@hawkeye.stone.uk.eu.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk,
       alan <alan@clueserver.org>
Subject: Re: Versioning file system
References: <46731169.2090002@hawkeye.stone.uk.eu.org>	<4673182B.4090800@redhat.com>	<46739E89.1080003@hawkeye.stone.uk.eu.org>	<46781A5B.9090104@redhat.com>	<467829C4.5020101@zytor.com> <20070619225021.225d4c7e@the-village.bc.nu>
In-Reply-To: <20070619225021.225d4c7e@the-village.bc.nu>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> 
> Yes but tdskb:foo.mac[1013,1013,frob];4 is *not* elegant.

I think describing VMS pathname syntax as "not elegant" is kind of like
describing George W. Bush as "not a genius."

> POSIX is very
> clear about what is acceptable as magic in a pathname, and the unix spec
> even more so.  The NetApp approach recognizes two important things
> 
> 1.	Old version access is the oddity not the norm
> 2.	Standards behaviour is important
> 

3. An atomic snapshot is more useful than a bunch of disconnected
per-file version.  Kind of like CVS vs SVN.

	-hpa
