Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbZG3HWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbZG3HWI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 03:22:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753865AbZG3HWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 03:22:08 -0400
Received: from smtp-out.google.com ([216.239.45.13]:58548 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZG3HWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 03:22:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=X0qyy3iLLnq5gEC3J5TwF/Vc/OpKbgxrPoG2iRU8ZXMTTBDc6KIIw006D6AhCGKTN
	6xh3DvDTPAfMw97+rnUug==
Date: Thu, 30 Jul 2009 00:21:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Thomas Meyer <thomas@m3y3r.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bug #13666] WARNING: at mm/page_alloc.c:1743
 __alloc_pages_nodemask
In-Reply-To: <200907280021.26320.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.0907300021330.7540@chino.kir.corp.google.com>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <3zAHs5O6maO.A.GwE.OIObKB@chimera> <alpine.DEB.2.00.0907261628180.17123@chino.kir.corp.google.com> <200907280021.26320.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009, Rafael J. Wysocki wrote:

> > This is fixed in mmotm with the following patches, waiting for Andrew's 
> > push to Linus:
> > 
> > 	page-allocator-allow-too-high-order-warning-messages-to-be-suppressed-with-__gfp_nowarn.patch
> > 	net-dccp-suppress-warning-about-large-allocations-from-dccp.patch
> 
> Thanks, updated.
> 

These patches have made it to Linus' tree, so this issue is resolved.
