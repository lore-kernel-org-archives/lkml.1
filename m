Return-Path: <linux-kernel-owner+w=401wt.eu-S1761138AbYCXPad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138AbYCXPad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 11:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760122AbYCXPaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 11:30:23 -0400
Received: from lazybastard.de ([212.112.238.170]:37530 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758604AbYCXPaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 11:30:22 -0400
Date: Mon, 24 Mar 2008 16:29:52 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Paul Mundt <lethal@linux-sh.org>, Greg KH <greg@kroah.com>,
       dwmw2 <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] 3/3 maple: update bus driver to support Dreamcast VMU
Message-ID: <20080324152952.GF2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209786.6324.41.camel@localhost.localdomain> <20080324033344.GB15872@linux-sh.org> <20080324144647.GC2899@logfs.org> <1206371178.6283.37.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1206371178.6283.37.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 March 2008 15:06:18 +0000, Adrian McMenamin wrote:
> 
> I don't think I have any alternative here. The problem is that the bus
> checks periodically (every HZ ticks but that could be changed) if a
> device remains connected to the system by queueing a status command. (If
> the status command is replied to with a "No response" then that
> indicates to the bus that the device has been removed.

Where does this queueing happen?  Somewhere in the kernel where we can
control it or in hardware?

Jörn

-- 
I don't understand it. Nobody does.
-- Richard P. Feynman
