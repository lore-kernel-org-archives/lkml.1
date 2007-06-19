Return-Path: <linux-kernel-owner+w=401wt.eu-S933947AbXFSUKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947AbXFSUKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 16:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933860AbXFSUKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 16:10:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37357 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933837AbXFSUK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 16:10:27 -0400
Date: Tue, 19 Jun 2007 13:10:21 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Olaf Hering <olaf@aepfle.de>
Newsgroups: gmane.linux.ports.ppc64.devel
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: 2.6.22: ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!
Message-ID: <20070619131021.1c814098@localhost.localdomain>
In-Reply-To: <20070619190253.GA19419@aepfle.de>
References: <20070619190253.GA19419@aepfle.de>
Organization: Linux Foundation
X-Newsreader: Claws Mail 2.9.2 (GTK+ 2.10.12; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 21:02:53 +0200
Olaf Hering <olaf@aepfle.de> wrote:

> 
> What happend to __ucmpdi2 from David Woodhouse?
> google has a few hits about stuff like this on 32bit powerpc with gcc 4.1.2:
> 
> ERROR: "__ucmpdi2" [drivers/net/s2io.ko] undefined!
> 
> using the drivers/net/s2io* files from 2.6.21 with 2.6.22-rc5 fixes the
> compile.
> 
> 25805dcf9d83098cf5492117ad2669cd14cc9b24 adds two u64 >>= 48 followed by
> a switch statement (line 2889 and 6816).

Probably the "switch(err) {" needs a cast to a smaller type (like u8).
-- 
Stephen Hemminger <shemminger@linux-foundation.org>
