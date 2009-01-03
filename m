Return-Path: <linux-kernel-owner+w=401wt.eu-S932462AbZACVyH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbZACVyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 16:54:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760050AbZACVxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 16:53:53 -0500
Received: from gate.crashing.org ([63.228.1.57]:37078 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760264AbZACVxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 16:53:52 -0500
Subject: Re: [PATCH] printk: Let %pR handle NULL pointers
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Trent Piepho <xyzzy@speakeasy.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       "David S. Miller" <davem@davemloft.net>
In-Reply-To: <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain>
References: <1230979341-23029-1-git-send-email-xyzzy@speakeasy.org>
	 <alpine.LFD.2.00.0901030905140.3179@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 08:53:34 +1100
Message-Id: <1231019614.15389.104.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-03 at 09:10 -0800, Linus Torvalds wrote:
> 
> On Sat, 3 Jan 2009, Trent Piepho wrote:
> >
> > Have %pR print "[NULL]" for the resource range when passed a NULL pointer.
> 
> Wouldn't it be much nicer to just do it for _all_ pointer types?
> 
> IOW, a patch more like the appended.

Agreed.

Cheers,
Ben.

