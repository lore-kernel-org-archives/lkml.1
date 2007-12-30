Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXL3Dzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXL3Dzj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:55:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbXL3Dzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:55:32 -0500
Received: from twinlark.arctic.org ([208.69.40.136]:59676 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbXL3Dzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:55:31 -0500
Date: Sat, 29 Dec 2007 19:55:29 -0800 (PST)
From: dean gaudet <dean@arctic.org>
To: Valdis.Kletnieks@vt.edu
cc: David Newall <david@davidnewall.com>, Mark Lord <lkml@rtr.ca>,
       Al Viro <viro@ftp.linux.org.uk>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: RFC: permit link(2) to work across --bind mounts ?
In-Reply-To: <25388.1198986232@turing-police.cc.vt.edu>
Message-ID: <alpine.DEB.0.999999.0712291954560.5207@twinlark.arctic.org>
References: <47684DBD.6030502@rtr.ca> <20071218230016.GF8181@ftp.linux.org.uk> <20071218231404.GG8181@ftp.linux.org.uk> <47689608.3030503@rtr.ca> <4768973C.8020909@davidnewall.com> <alpine.DEB.0.999999.0712281835240.5207@twinlark.arctic.org>
 <47760578.2090305@davidnewall.com> <alpine.DEB.0.999999.0712290754230.5207@twinlark.arctic.org> <4776AF82.6010808@davidnewall.com>            <alpine.DEB.0.999999.0712291239360.5207@twinlark.arctic.org> <25388.1198986232@turing-police.cc.vt.edu>
User-Agent: Alpine 0.999999 (DEB 847 2007-12-06)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, Valdis.Kletnieks@vt.edu wrote:

> On Sat, 29 Dec 2007 12:40:47 PST, dean gaudet said:
> 
> > the main worry i have is some user maliciously hardlinks everything
> > under /var/log somewhere else and slowly fills up the file system with
> > old rotated logs.
> 
> "Doctor, it hurts when I do this.." "Well, don't do that then".

actually it doesn't hurt.  i have other mechanisms which would pick this 
up fairly quickly.

-dean
