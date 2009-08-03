Return-Path: <linux-kernel-owner+w=401wt.eu-S1753381AbZHCIRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381AbZHCIRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 04:17:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035AbZHCIRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 04:17:22 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:54365 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbZHCIRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 04:17:21 -0400
Date: Mon, 3 Aug 2009 10:17:05 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, Anders Kaseorg <andersk@ksplice.com>,
       Nelson Elhage <nelhage@ksplice.com>, Tim Abbott <tabbott@ksplice.com>
Subject: Re: [PATCH 1/2] s390: Use macros for .data.page_aligned.
Message-ID: <20090803101705.02d77367@skybase>
In-Reply-To: <1249073911-30208-1-git-send-email-tabbott@ksplice.com>
References: <1249073911-30208-1-git-send-email-tabbott@ksplice.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Jul 2009 16:58:30 -0400
Tim Abbott <tabbott@ksplice.com> wrote:

> .data.page_aligned should not need a separate output section, so as
> part of this cleanup I moved into the .data output section in the
> linker scripts in order to eliminate unnecessary references to the
> section name.
> 
> Remove the reference to .data.idt, since nothing is put into the
> .data.idt section on the s390 architecture.  It looks like Cyrill
> Gorcunov posted a patch to remove the .data.idt code on s390
> previously:
> 
> <http://lkml.indiana.edu/hypermail/linux/kernel/0802.2/2536.html>
> 
> CCing him and the people who acked that patch in case there's a reason
> it wasn't applied.
> 
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
> Cc: Sam Ravnborg <sam@ravnborg.org>

I'll add the patch to the git390 queue. Thanks.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

