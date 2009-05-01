Return-Path: <linux-kernel-owner+w=401wt.eu-S1763064AbZEAOfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763064AbZEAOfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 10:35:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755864AbZEAOfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 10:35:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46268 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbZEAOfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 10:35:31 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
References: <1241135661-9147-1-git-send-email-tabbott@mit.edu>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>
Subject: Re: [PATCH 0/6] section name cleanup for mn10300
Date: Fri, 01 May 2009 15:35:19 +0100
Message-ID: <2425.1241188519@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@MIT.EDU> wrote:

> This patch series cleans up the section names on the mn10300
> architecture.  It requires the architecture-independent macro
> definitions from this patch series:

Interesting...  Whilst it compiles and links with no problems, this cleanup
has the following detrimental effects:

None of these patches applied

	   text    data     bss     dec     hex filename
	1879329   82980  321772 2284081  22da31 vmlinux

All of these patches applied:

	   text    data     bss     dec     hex filename
	1879329   87076  321772 2288177  22ea31 vmlinux

Somewhere it eats an extra page.

David
