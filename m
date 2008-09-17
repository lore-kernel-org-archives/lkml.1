Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbYIQVqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbYIQVqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:46:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYIQVp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:45:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:38680 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYIQVpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:45:55 -0400
Date: Wed, 17 Sep 2008 14:45:58 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: warn: Turn the netdev timeout WARN_ON() into a WARN()
Message-ID: <20080917144558.6ed2e6b8@linux.intel.com>
In-Reply-To: <48D178FB.80902@garzik.org>
References: <200809170259.m8H2xClI020907@hera.kernel.org>
	<20080917032708.GA8431@havoc.gtf.org>
	<20080917064128.2b2f8616@linux.intel.com>
	<48D178FB.80902@garzik.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Sep 2008 17:39:07 -0400
Jeff Garzik <jeff@garzik.org> wrote:
\
> 
> ACK, this fixes my objection, thanks

ok

> > If all the networking guys agree that the report
> > has no value for developers because they're all unfixable hardware
> > bugs,
> 
> You misunderstand; reporting and tracking these issues have value,
> but the information you are dumping (specifically the backtrace) does
> not.

WARN() is about a lot more than a backtrace, but point taken, see below
> 
> I think it would benefit Linux if our bugs announce themselves in a 
> standard way, but the backtrace is not a key part of that, and IMO 
> should be optional.

I cannot disagree with the "the backtrace is not useful" statement for
this case. I don't even mind making a WARN() variant that doesn't
backtrace; I'll look into that. I don't consider it "2.6.27 urgent"
though; a backtrace is pretty light to do for such an exceptional
slowpath case, and the only real effect is a few lines
in /var/log/messages that are somewhat redundant.

 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
