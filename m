Return-Path: <linux-kernel-owner+w=401wt.eu-S1751296AbXBFH5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbXBFH5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 02:57:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbXBFH5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 02:57:03 -0500
Received: from mail.suse.de ([195.135.220.2]:56356 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbXBFH5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 02:57:01 -0500
From: Andi Kleen <ak@suse.de>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Subject: Re: [patch] mtrr: fix issues with large addresses
Date: Tue, 6 Feb 2007 08:53:30 +0100
User-Agent: KMail/1.9.5
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>, linux-kernel@vger.kernel.org,
       discuss@x86-64.org, Richard Gooch <rgooch@safe-mbox.com>
References: <20070205171959.GF8665@alberich.amd.com> <20070205145055.A19581@unix-os.sc.intel.com>
In-Reply-To: <20070205145055.A19581@unix-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702060853.30812.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 February 2007 23:50, Siddha, Suresh B wrote:
> On Mon, Feb 05, 2007 at 06:19:59PM +0100, Andreas Herrmann wrote:
> > o added check to restrict base address to 36 bit on i386
> 
> Why is this? It can go upto implemented physical bits, right?

In theory it can, but Linux doesn't support it.

-Andi 
