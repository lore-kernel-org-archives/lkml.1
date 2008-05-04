Return-Path: <linux-kernel-owner+w=401wt.eu-S1758130AbYEDVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758130AbYEDVjf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 17:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbYEDVj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 17:39:28 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:55786 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbYEDVj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 17:39:27 -0400
Message-ID: <481E2D35.6080600@keyaccess.nl>
Date: Sun, 04 May 2008 23:40:05 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Joe Perches <joe@perches.com>,
       linux-next@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] PNP: fix printk format warnings
References: <20080430135608.8b6ee7e0.randy.dunlap@oracle.com> <1209589640.5041.67.camel@localhost> <481E0C13.9010907@keyaccess.nl> <481E2535.8080301@oracle.com>
In-Reply-To: <481E2535.8080301@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04-05-08 23:05, Randy Dunlap wrote:

> My original patch did (int) cast but Joe suggested using unsigned long
> long.  I didn't expect DMA channel or irq to be anywhere near that large,
> so I thought that (int) would be sufficient, at the same time recognizing
> that it does/could truncate the value, while ull won't truncate.

Yes, (int) would've been fine. It's (int) in PnPACPI as well which is what I 
remebered seeing. Doesn't matter much ofcourse.

Rene.
