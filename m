Return-Path: <linux-kernel-owner+w=401wt.eu-S1761107AbXHVJmD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761107AbXHVJmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:42:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbXHVJly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 05:41:54 -0400
Received: from mx1.suse.de ([195.135.220.2]:52521 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158AbXHVJly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 05:41:54 -0400
Date: Wed, 22 Aug 2007 12:35:45 +0200
From: Andi Kleen <ak@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Avi Kivity <avi@qumranet.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>
Subject: Re: [PATCH] Add I/O hypercalls for i386 paravirt
Message-ID: <20070822103545.GG2642@bingen.suse.de>
References: <46CBC842.4070100@vmware.com> <46CBCADF.2070400@qumranet.com> <1187763956.6174.48.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187763956.6174.48.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch also means I can kill off the emulation code in
> drivers/lguest/core.c, which is a real relief.

But would it be faster? If not or only insignificant amount I think I would 
prefer you keep it. Hooking IO is quite intrusive because it's done
by so many drivers.

-Andi
