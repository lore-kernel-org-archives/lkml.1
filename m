Return-Path: <linux-kernel-owner+w=401wt.eu-S1755250AbYJ3N2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250AbYJ3N2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 09:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYJ3N2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 09:28:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:33387 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbYJ3N2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 09:28:04 -0400
Date: Thu, 30 Oct 2008 06:28:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@suse.cz>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] corruption checker: print the DMI board name
Message-ID: <20081030062830.31023884@infradead.org>
In-Reply-To: <20081030110653.GA7291@atrey.karlin.mff.cuni.cz>
References: <20081029091703.47628e54@infradead.org>
	<20081030110653.GA7291@atrey.karlin.mff.cuni.cz>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2008 12:06:53 +0100
Pavel Machek <pavel@suse.cz> wrote:

> > 
> > >From 4f829eef5a31b68a0cbaf83a75ac8b0a1ed05afb Mon Sep 17 00:00:00
> > >2001
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Wed, 29 Oct 2008 09:13:23 -0700
> > Subject: [PATCH] corruption checker: print the DMI board name
> > 
> > when the memory corruptor checker hits (as it has done now based on
> > kerneloops.org data), it would be extremely useful to know the DMI
> > board name so we can add a blacklist for such a machine... without
> > having to ask the user for lots of extra info.
> 
> I'm not sure if blacklisting whole brand for one case of bit
> corruption is fair -- perhaps the memory was overheating?

this is where kerneloops.org comes in; we can separate the "happens a
lot" from "happens on blue moons"

> 
>   
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> But ACK -- we certainly want to see the data.
