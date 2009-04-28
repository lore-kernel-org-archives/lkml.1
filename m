Return-Path: <linux-kernel-owner+w=401wt.eu-S1758479AbZD1V2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479AbZD1V2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 17:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754507AbZD1V2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 17:28:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40932 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754823AbZD1V2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 17:28:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1240938062-3264-2-git-send-email-tabbott@mit.edu>
References: <1240938062-3264-2-git-send-email-tabbott@mit.edu> <1240938062-3264-1-git-send-email-tabbott@mit.edu>
To: Tim Abbott <tabbott@MIT.EDU>
Cc: dhowells@redhat.com, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v2 01/15] Add new macros for page-aligned data and bss sections.
Date: Tue, 28 Apr 2009 22:27:12 +0100
Message-ID: <1301.1240954032@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tim Abbott <tabbott@MIT.EDU> wrote:

> This patch is preparation for replacing most uses of
> ".bss.page_aligned" and ".data.page_aligned" in the kernel with
> macros, so that the section name can later be changed without having
> to touch a lot of the kernel.
> 
> The long-term goal here is to be able to change the kernel's magic
> section names to those that are compatible with -ffunction-sections
> -fdata-sections.  This requires renaming all magic sections with names
> of the form ".data.foo".
> 
> Signed-off-by: Tim Abbott <tabbott@mit.edu>
> Cc: Sam Ravnborg <sam@ravnborg.org>

Acked-by: David Howells <dhowells@redhat.com>
