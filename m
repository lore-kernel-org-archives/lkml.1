Return-Path: <linux-kernel-owner+w=401wt.eu-S933695AbXKOWCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933695AbXKOWCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759439AbXKOWCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:02:09 -0500
Received: from ns2.g-housing.de ([81.169.133.75]:52937 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757373AbXKOWCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:02:08 -0500
Date: Thu, 15 Nov 2007 23:01:56 +0100 (CET)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: LKML <linux-kernel@vger.kernel.org>
cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Benny Halevy <bhalevy@panasas.com>, Chris Wedgwood <cw@f00f.org>,
       linux-xfs@oss.sgi.com
Subject: Re: 2.6.24-rc2 XFS nfsd hang / smbd too
In-Reply-To: <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
Message-ID: <alpine.DEB.0.99999.0711152258130.30603@sheep.housecafe.de>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de> <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
User-Agent: Alpine 0.99999 (DEB 796 2007-11-08)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Christian Kujau wrote:
> Upon accessing the /data/sub part of the CIFS share, the client hung, waiting 
> for the server to respond (the [cifs] kernel thread on the client was 
> spinning, waiting for i/o). On the server, similar things as with the nfsd 
> processes happened

Turns out that the CIFS only hung because the server was already stuck 
because of the nfsd/XFS issue. After rebooting the server, I was 
able to access the CIFS shares (the xfs partition too) just fine. Yes, the 
xfs partition itsself has been checked too and no errors were found.

C.
-- 
BOFH excuse #348:

We're on Token Ring, and it looks like the token got loose.
