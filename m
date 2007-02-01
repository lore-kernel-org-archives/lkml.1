Return-Path: <linux-kernel-owner+w=401wt.eu-S1422817AbXBALhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422817AbXBALhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 06:37:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422825AbXBALhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 06:37:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:56478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422816AbXBALgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 06:36:36 -0500
From: Andi Kleen <ak@suse.de>
To: jbohac@suse.cz
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Date: Thu, 1 Feb 2007 12:14:23 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Vojtech Pavlik <vojtech@suse.cz>,
       ssouhlal@freebsd.org, arjan@infradead.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
References: <20070201095952.589234000@jet.suse.cz> <20070201103753.753349000@jet.suse.cz>
In-Reply-To: <20070201103753.753349000@jet.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702011214.24126.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 February 2007 10:59, jbohac@suse.cz wrote:
> TSC is either synchronized by design or not reliable
> to be used for anything, let alone timekeeping.

In my tree this is already done better by a patch from Ingo.
Check if they look synchronized and don't use TSC if they are not.

-Andi
