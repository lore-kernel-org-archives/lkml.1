Return-Path: <linux-kernel-owner+w=401wt.eu-S1759467AbYGaV6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759467AbYGaV6m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 17:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758573AbYGaV6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 17:58:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:46123 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376AbYGaV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 17:58:15 -0400
Date: Thu, 31 Jul 2008 14:56:01 -0700
From: Greg KH <greg@kroah.com>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Rene Herman <rene.herman@keyaccess.nl>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, Daniel Walker <dwalker@mvista.com>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [patch 5/3] fastboot: sync the async execution before
	late_initcall and move level 6s (sync) first
Message-ID: <20080731215601.GC4817@kroah.com>
References: <Pine.LNX.4.44L0.0807311110300.4409-100000@iolanthe.rowland.org> <48920481.7010702@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48920481.7010702@simon.arlott.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 31, 2008 at 07:29:21PM +0100, Simon Arlott wrote:
>>> There is nothing else to run between 1-2 and 3, so there is no 
>>> opportunity
>>> to initialise devices in the background and usblp_init blocks for a 
>>> while.
>> If it were a module then it would block in a separate thread and wouldn't 
>> hold up the main init process.
>
> Right, but I want to compile all of this into the kernel.

Why?  It sounds like a trivial solution for you is to actually use
modules.  Why go through a lot of extra work to solve something in a
different way that is already solved for you?

Who is imposing the "no modules allowed" rule on you, and why was it
made?

thanks,

greg k-h
