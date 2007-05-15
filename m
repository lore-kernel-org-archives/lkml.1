Return-Path: <linux-kernel-owner+w=401wt.eu-S933617AbXEOJR2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbXEOJR2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:17:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759220AbXEOJRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:17:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45484 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758423AbXEOJRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:17:21 -0400
Message-ID: <46497A9D.7000905@garzik.org>
Date: Tue, 15 May 2007 05:17:17 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: __must_check (stir the pot :-))
References: <20070515173146.505952d1.sfr@canb.auug.org.au>
In-Reply-To: <20070515173146.505952d1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> where sysfs_create_file() is marked __must_check and sysdev_create_file()
> isn't.
> 
> So the questions come to mind:  Do we really care if our core
> infrastructure doesn't?  Can we care if the core infrastructure doesn't
> propogate the error returns?


Yes, we should propagate the markers as needed...

	Jeff


