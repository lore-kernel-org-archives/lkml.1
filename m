Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbYDNIo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbYDNIo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:44:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYDNIot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:44:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756799AbYDNIos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:44:48 -0400
Date: Mon, 14 Apr 2008 04:43:20 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, mingo <mingo@redhat.com>,
       tglx <tglx@linutronix.de>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 10 (arch/x86)
Message-ID: <20080414084320.GE23259@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080410181404.b76939a6.sfr@canb.auug.org.au> <20080410150950.5913b16a.randy.dunlap@oracle.com> <20080411074631.GB6410@elte.hu> <20080411081901.f56f5180.randy.dunlap@oracle.com> <20080411152648.GK9785@ZenIV.linux.org.uk> <20080414081220.GA19865@elte.hu> <20080414082220.GZ9785@ZenIV.linux.org.uk> <20080414083440.GD19865@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414083440.GD19865@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 10:34:40AM +0200, Ingo Molnar wrote:
> ... but reality called in and gcc added printf format checks as a gcc 
> extension and even modifies the code to make it safe when the user gets 
> it "wrong".

GCC format string checking is only about warnings, GCC never modifies
the arguments passed to make them match the format string conversions.

	Jakub
