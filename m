Return-Path: <linux-kernel-owner+w=401wt.eu-S1753915AbYITWlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbYITWlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 18:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYITWlS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 18:41:18 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:18496 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYITWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 18:41:17 -0400
Date: Sat, 20 Sep 2008 15:41:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debug: Introduce a dev_WARN() function
Message-Id: <20080920154102.2887afdc.randy.dunlap@oracle.com>
In-Reply-To: <20080919231304.32afb437@infradead.org>
References: <20080919210733.4e9c58e8@infradead.org>
	<20080920042630.GA21501@kroah.com>
	<20080919231304.32afb437@infradead.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 23:13:04 -0700 Arjan van de Ven wrote:

> On Fri, 19 Sep 2008 21:26:30 -0700
> Greg KH <greg@kroah.com> wrote:
> 
> > > in the line of dev_printk(), this patch introduces a dev_WARN()
> > > macro, that takes a struct device and then a printk format/args set
> > > of arguments. Unlike dev_printk(), the effect is that of WARN() in
> > > that a full warning message (including filename/line, module list,
> > > versions and a backtrace) is printed in addition to the device name
> > > and the arguments.
> > 
> > I like the idea, but we already have dev_warn(), so dev_WARN() might
> > be a bit confusing for people.
> > 
> > Perhaps just documenting it with a docbook tag would suffice?
> 
> I didn't think we could do kerneldoc for macros? But maybe I just
> misremember

It works fine.


---
~Randy
