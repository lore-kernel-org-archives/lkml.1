Return-Path: <linux-kernel-owner+w=401wt.eu-S935821AbXJQA6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935821AbXJQA6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 20:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760879AbXJQA6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 20:58:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:36344 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbXJQA6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 20:58:06 -0400
Date: Tue, 16 Oct 2007 17:56:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Regression: GRUB from openSUSE 10.2 doesn't boot current -git
Message-Id: <20071016175602.e91e2d59.randy.dunlap@oracle.com>
In-Reply-To: <200710170233.20445.rjw@sisk.pl>
References: <200710170233.20445.rjw@sisk.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007 02:33:19 +0200 Rafael J. Wysocki wrote:

> Hi,
> 
> As stated in the subject, I cannot boot the current -git (most recent commit
> 821f3eff7cdb9d6c7076effabd46c96c322daed1) using GRUB on x86-64 openSUSE 10.2.
> 
> The GRUB says that the kernel image is too big and doesn't fit into memory, but
> the kernel has been built and installed in exactly the same way as all of the
> previous -git kernels.

kbuild patch from Sam should fix it:
http://lkml.org/lkml/2007/10/16/395

or one from Eric:
http://lkml.org/lkml/2007/10/16/429

---
~Randy
