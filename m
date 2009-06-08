Return-Path: <linux-kernel-owner+w=401wt.eu-S1756049AbZFHRXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049AbZFHRXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZFHRVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:21:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:54507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZFHRVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:21:15 -0400
Date: Mon, 8 Jun 2009 10:21:08 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Matt Carlson <mcarlson@broadcom.com>
cc: LKML <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: tg3 stops working when NFS is involved
In-Reply-To: <20090608164038.GA8825@xw6200.broadcom.net>
Message-ID: <alpine.DEB.2.01.0906081013530.6439@bogon>
References: <alpine.DEB.2.01.0906072115420.6439@bogon> <alpine.DEB.2.01.0906072215000.6439@bogon> <20090608164038.GA8825@xw6200.broadcom.net>
User-Agent: Alpine 2.01 (DEB 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX196clK2Z7nUl/5DymRZbUuFIab/orir3twXP33
 FpAXN1Zt2xeT/VeV4LNIZa0C9IGGmZ+VytBmk+bTAh07+ycrIB
 gtmyeKkMFSNduZUWKukVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009, Matt Carlson wrote:
> This seems to be a common problem with the 5906 on some
> notebooks.  The word on the street is that turning sg off through
> ethtool seems to avoid the problem.

Well, I must've been on the wrong streets then, this was news to me...

> While I dig deeper into this
> problem, you could try that and see if it helps you.

Yes, "ethtool -K eth0 sg off" does indeed help here too: I've already 
transmitted a few gigabytes of traffic (the problem occured after a few 
megabytes lastly) and all is still well.

Thanks for your quick response!
Christian.
-- 
BOFH excuse #273:

The cord jumped over and hit the power switch.
