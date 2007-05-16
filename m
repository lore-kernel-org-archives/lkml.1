Return-Path: <linux-kernel-owner+w=401wt.eu-S1760300AbXEPPq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760300AbXEPPq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbXEPPqu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:46:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34894 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755123AbXEPPqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:46:49 -0400
Date: Wed, 16 May 2007 08:34:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: =?ISO-8859-1?B?SvZybg==?= Engel <joern@lazybastard.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
Message-Id: <20070516083408.dcd9dd78.akpm@linux-foundation.org>
In-Reply-To: <1179317240.2859.222.camel@shinybook.infradead.org>
References: <20070515151919.GA32510@lazybastard.org>
	<20070515133759.9ee434a2.akpm@linux-foundation.org>
	<1179317240.2859.222.camel@shinybook.infradead.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 20:07:18 +0800 David Woodhouse <dwmw2@infradead.org> wrote:

> > It's strange and a bit regrettable that an fs would have dependency on MTD,
> > really.
> 
> Why? Other file systems has dependencies on BLOCK or on NET. It seems
> entirely normal to me.

Reduced testability, mainly. Also potentially reduced usefulness.
