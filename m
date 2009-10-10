Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbZJJWSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbZJJWSR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 18:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZJJWSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 18:18:16 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:55785 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752362AbZJJWSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 18:18:15 -0400
Date: Sat, 10 Oct 2009 23:17:36 +0100
From: Ben Dooks <ben@fluff.org>
To: Ben Dooks <ben@fluff.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: make mrproper not resetting kernel saved arch
Message-ID: <20091010221736.GB7793@fluff.org.uk>
References: <20091010212505.GA7793@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091010212505.GA7793@fluff.org.uk>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 10:25:05PM +0100, Ben Dooks wrote:
> Having accidentally configured for the wrong arch, I tried going back to ARM
> but got the following errro:
> 
> Makefile:210: *** ARCH changed from "x86_64" to "arm". Use "make mrproper" to fix it up.  Stop.
> 
> Trying to do 'make mrproper' repeats the error:
> 
> $ make mrproper
> Makefile:210: *** ARCH changed from "x86_64" to "arm". Use "make mrproper" to fix it up.  Stop.
> 
> I ended up doing 'rm -r include/generated' to get rid of this.
> 
> My makefile understanding isn't good enough to repair this, so can someone
> please fix this.

Add changing cross compiler to this list.
