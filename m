Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYITGNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYITGNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 02:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbYITGNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 02:13:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:59197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYITGNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 02:13:07 -0400
Date: Fri, 19 Sep 2008 23:13:04 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Greg KH <greg@kroah.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debug: Introduce a dev_WARN() function
Message-ID: <20080919231304.32afb437@infradead.org>
In-Reply-To: <20080920042630.GA21501@kroah.com>
References: <20080919210733.4e9c58e8@infradead.org>
	<20080920042630.GA21501@kroah.com>
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

On Fri, 19 Sep 2008 21:26:30 -0700
Greg KH <greg@kroah.com> wrote:

> > in the line of dev_printk(), this patch introduces a dev_WARN()
> > macro, that takes a struct device and then a printk format/args set
> > of arguments. Unlike dev_printk(), the effect is that of WARN() in
> > that a full warning message (including filename/line, module list,
> > versions and a backtrace) is printed in addition to the device name
> > and the arguments.
> 
> I like the idea, but we already have dev_warn(), so dev_WARN() might
> be a bit confusing for people.
> 
> Perhaps just documenting it with a docbook tag would suffice?

I didn't think we could do kerneldoc for macros? But maybe I just
misremember


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
