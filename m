Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbYA3NYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbYA3NYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:24:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbYA3NX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:23:59 -0500
Received: from cantor.suse.de ([195.135.220.2]:35979 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYA3NX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:23:58 -0500
From: Andi Kleen <ak@suse.de>
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: ioremap_xxx() with EXEC enabled
Date: Wed, 30 Jan 2008 14:22:40 +0100
User-Agent: KMail/1.9.1
Cc: "Huang, Ying" <ying.huang@intel.com>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1201685530.17912.11.camel@caritas-dev.intel.com> <200801301059.40568.ak@suse.de> <851fc09e0801300500p3efe8602yd3219e44856486f9@mail.gmail.com>
In-Reply-To: <851fc09e0801300500p3efe8602yd3219e44856486f9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801301422.40912.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The the last parameter of the current implementation of __ioremap() in
> x86 git is  enum ioremap_mode (IOR_MODE_UNCACHED and IOR_MODE_CACHED),
> not the flags like before. So this does not work.

Ah you're right sorry. Looks like a design flaw in the recent git-x86 changes.

-Andi
