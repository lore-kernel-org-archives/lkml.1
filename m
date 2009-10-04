Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZJDX1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZJDX1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 19:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZJDX1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 19:27:24 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48442 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZJDX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 19:27:23 -0400
Date: Mon, 5 Oct 2009 01:26:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Shane Wang <shane.wang@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Cihula, Joseph" <joseph.cihula@intel.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "andi@firstfloor.org" <andi@firstfloor.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>
Subject: Re: [PATCH] intel_txt: add s3 userspace memory integrity verification
Message-ID: <20091004232639.GQ1656@one.firstfloor.org>
References: <4A9CE0B2.5060608@intel.com> <4ABF2B50.6070106@intel.com> <20091004185801.GC1378@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004185801.GC1378@ucw.cz>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So I corrupt memory, but also corrupt tboot_enabled() to return 0....
> 
> And... does panic kill the machine quickly enough that no 'bad stuff'
> happens? (Whats bad stuff in this context, anyway?).

panic has notifiers, so indeed someone could put arbitary code into panic.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
