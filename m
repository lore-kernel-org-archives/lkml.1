Return-Path: <linux-kernel-owner+w=401wt.eu-S1755410AbXGaI6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410AbXGaI6m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 04:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752545AbXGaI6f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 04:58:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53646 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbXGaI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 04:58:34 -0400
Date: Tue, 31 Jul 2007 01:57:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Cc: kkeil@suse.de, kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] Use mutex instead of semaphore in ISDN subsystem
 common functions
Message-Id: <20070731015749.ac549e71.akpm@linux-foundation.org>
In-Reply-To: <20070729214105.GG3432@traven>
References: <20070729212909.GC3432@traven>
	<20070729214105.GG3432@traven>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 23:41:05 +0200 Matthias Kaehlcke <matthias.kaehlcke@gmail.com> wrote:

> --- a/include/linux/isdn.h
> +++ b/include/linux/isdn.h
> @@ -15,6 +15,7 @@
>  #define __ISDN_H__
>  
>  #include <linux/ioctl.h>
> +#include <linux/mutex.h>

Breaks `make headers_check'.

That was covered in sections 2 and 20 of Documentation/SubmitChecklist,
which nobody reads.
