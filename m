Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbYIGTIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbYIGTIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 15:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYIGTIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 15:08:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:58535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbYIGTIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 15:08:36 -0400
Date: Sun, 7 Sep 2008 12:08:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Oruba <peter.oruba@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       LKML <linux-kernel@vger.kernel.org>, Peter Oruba <peter.oruba@amd.com>
Subject: Re: [patch 05/11] [PATCH 05/11] x86: Moved microcode.c to
 microcode_intel.c.
Message-ID: <20080907120823.59f8fa47@infradead.org>
In-Reply-To: <20080728164448.492961653@amd.com>
References: <20080728164411.490752571@amd.com>
	<20080728164448.492961653@amd.com>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 18:44:16 +0200
Peter Oruba <peter.oruba@amd.com> wrote:

> Signed-off-by: Peter Oruba <peter.oruba@amd.com>
> ---
>  arch/x86/kernel/Makefile          |    2 +-
>  arch/x86/kernel/microcode.c       |  855

\


unfortunately this patch breaks userland for me; the Fedora initscripts
suddenly fail (with a [FAILED] that will alarm users) because of this
rename.... 
(well it also fails to update the microcode, and if you load the new
module name by hand first it still fails in many ways ;-( )

That is a regression in -tip unfortunately....
