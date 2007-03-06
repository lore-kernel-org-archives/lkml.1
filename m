Return-Path: <linux-kernel-owner+w=401wt.eu-S965470AbXCFSQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965470AbXCFSQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:16:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965505AbXCFSQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:16:09 -0500
Received: from gw.goop.org ([64.81.55.164]:33059 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965470AbXCFSQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:16:04 -0500
Message-ID: <45EDAFE1.1090106@goop.org>
Date: Tue, 06 Mar 2007 10:16:01 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Re: [PATCH 5/8] Cleanup GDT access
References: <1173184747.4644.23.camel@localhost.localdomain>	 <1173185592.4644.28.camel@localhost.localdomain>	 <1173185666.4644.30.camel@localhost.localdomain>	 <1173185734.4644.32.camel@localhost.localdomain>	 <1173185827.4644.34.camel@localhost.localdomain> <1173185909.4644.36.camel@localhost.localdomain>
In-Reply-To: <1173185909.4644.36.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> Now we have an explicit per-cpu GDT variable, we don't need to keep
> the descriptors around to use them to find the GDT.  Also remove the
> cpu_pda() accessor: it's just a per-cpu variable.
>   
Looks good.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>

    J
