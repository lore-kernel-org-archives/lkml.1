Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYFZH0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYFZH0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 03:26:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbYFZH0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 03:26:24 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:51895 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbYFZH0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 03:26:22 -0400
Subject: Re: [patch 07/21] Cleanup sclp printk messages.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Bastian Blank <bastian@waldi.eu.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
In-Reply-To: <20080625151544.GA12945@wavehammer.waldi.eu.org>
References: <20080625143459.100139455@de.ibm.com>
	 <20080625143613.141370129@de.ibm.com>
	 <20080625151544.GA12945@wavehammer.waldi.eu.org>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 26 Jun 2008 09:26:16 +0200
Message-Id: <1214465176.12809.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-25 at 17:15 +0200, Bastian Blank wrote:
> On Wed, Jun 25, 2008 at 04:35:06PM +0200, Martin Schwidefsky wrote:
> > +	if (finished_sccb != (u32) (addr_t) sclp_init_sccb)
> > +		panic("sclp: unsolicited interrupt for buffer at 0x%x\n",
> > +		      finished_sccb);
> 
> Does that really need to be a panic?

Yes, that should be a panic. The point is that we got an unsolicited
interrupt from sclp at boot time. That means that there has been an sclp
request around from the last incarnation of the system. An sclp request
can do a lot of things, in particular it can change memory. Not a good
start for the new system ..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


