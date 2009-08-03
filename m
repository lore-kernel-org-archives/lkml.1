Return-Path: <linux-kernel-owner+w=401wt.eu-S1752357AbZHCRph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357AbZHCRph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 13:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZHCRpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 13:45:36 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2293 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbZHCRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 13:45:36 -0400
Subject: RE: [PATCH] Moorestown RAR Handler driver, MRST 2.6.31-rc3
From: Joe Perches <joe@perches.com>
To: "Othman, Ossama" <ossama.othman@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <A5FE05C4C76E4C4CAB15D9962B96FC950C7957A872@orsmsx510.amr.corp.intel.com>
References: <1249082419-27718-1-git-send-email-ossama.othman@intel.com>
	 <20090801073053.GA30389@merkur.ravnborg.org>
	 <A5FE05C4C76E4C4CAB15D9962B96FC950C7957A872@orsmsx510.amr.corp.intel.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 10:45:33 -0700
Message-Id: <1249321533.5149.21.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-03 at 10:32 -0700, Othman, Ossama wrote:
> >It is recommended to separate definition,
> >and assignment.
> >So this should look like this:
> >	struct memrar_allocator *allocator;
> >	allocator = 0;
> Okay, I'll fix that, too.  Should this go into Documentation/CodingStyle, too?

I don't agree with that at all, neither does a lot of the kernel source.

Automatic structs with initializers:
$ grep -rP --include=*.c "^\s+struct\s+\w+\s*\*\s*\w+\s*=\s*\w+\s*;" * | wc -l
9498

I think it should be struct memrar_allocator *allocator = NULL;


