Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZGZXab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZGZXab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 19:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZGZXaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 19:30:30 -0400
Received: from smtp-out.google.com ([216.239.45.13]:43568 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbZGZXa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 19:30:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=T9I0+peB5DlqhyQhNpgCEHlC+kfew7Y1JfYoPQJ/7TZruzTXJFeWC59jIY78f0EnE
	WeUd41bSUeCPcQr/HCrrw==
Date: Sun, 26 Jul 2009 16:30:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
In-Reply-To: <3zAHs5O6maO.A.GwE.OIObKB@chimera>
Message-ID: <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.GwE.OIObKB@chimera>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jul 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.30.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13666
> Subject		: WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2009-06-27 16:15 (30 days old)
> References	: http://lkml.org/lkml/2009/6/27/75
> 		  http://lkml.org/lkml/2009/7/7/6
> 

This is fixed in mmotm with the following patches, waiting for Andrew's 
push to Linus:

	page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
	net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
