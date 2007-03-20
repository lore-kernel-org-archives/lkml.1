Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbXCTHOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbXCTHOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 03:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753327AbXCTHOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 03:14:23 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46191 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbXCTHOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 03:14:22 -0400
Date: Tue, 20 Mar 2007 08:14:04 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Bob Tracy <rct@gherkin.frus.com>
cc: linux-kernel@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [BUG] no boot with 2.6.21-rc3 and later
In-Reply-To: <20070320014353.B1B05DBA1@gherkin.frus.com>
Message-ID: <Pine.LNX.4.64.0703200812130.5030@twin.jikos.cz>
References: <20070320014353.B1B05DBA1@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2007, Bob Tracy wrote:

> I applied all of the 2.6.21-rc2-rc3 incremental patch except for the 
> portion applicable to "drivers/ide" files.  The problem seems to be 
> elsewhere: 2.6.21-rc3 minus the drivers/ide changes still hangs at the 
> same spot during the boot process. Any ideas where to look next?  
> Thanks!

This really is an excellent opportunity for git-bisect, as you are 
trivially and immediately able to reproduce the problem. There are not 
that many patches between rc2 and rc3, so it would require only a few 
reboots to identify offending patch, and git-bisect is really trivial to 
use - see the manpage for the example on the process of bisecting.

-- 
Jiri Kosina
