Return-Path: <linux-kernel-owner+w=401wt.eu-S1752558AbXLCQOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbXLCQOg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 11:14:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXLCQO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 11:14:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53942 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012AbXLCQO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 11:14:29 -0500
Date: Mon, 3 Dec 2007 08:12:43 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Kyle Rose <krose@krose.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: OOPS at mm/rmap.c:628
Message-ID: <20071203081243.0a8ad658@laptopd505.fenrus.org>
In-Reply-To: <47542108.1050104@krose.org>
References: <47542108.1050104@krose.org>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Dec 2007 10:30:16 -0500
Kyle Rose <krose@krose.org> wrote:

> Not on the list, so please be sure to include me in any
> replies/comments/questions.
> 
> Thanks,
> Kyle
> 
> 
> 
> Ubuntu 2.6.22-14 source (2.6.22.9 with some other patches,
> presumably). x86_64
> Intel Core 2 Duo E6600
> 4G
> 
> 
> kern.log output:
> 
> Dec  3 06:10:02 kai kernel: [3080315.180287] ------------[ cut here
> ]------------
> Dec  3 06:10:02 kai kernel: [3080315.180289] kernel BUG at
> mm/rmap.c:628! Dec  3 06:10:02 kai kernel: [3080315.180292] invalid


Hi,

Thank you for your report.
there have been several reports (at least 8 on lkml already) of this
BUG() before for 2.6.22 (and a few before that), however nobody has
reported this in 2.6.23 or later, so it's very likely something that
this got fixed since in a later kernel....

Greetings,
    Arjan van de Ven

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
