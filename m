Return-Path: <linux-kernel-owner+w=401wt.eu-S1762904AbZJOQZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762904AbZJOQZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758510AbZJOQZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:25:04 -0400
Received: from www.tglx.de ([62.245.132.106]:54660 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757311AbZJOQZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:25:03 -0400
Date: Thu, 15 Oct 2009 18:23:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeff Garzik <jeff@garzik.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Remove or convert empty ioctls ?
In-Reply-To: <4AD747EB.3040008@garzik.org>
Message-ID: <alpine.LFD.2.00.0910151822280.9428@localhost.localdomain>
References: <alpine.LFD.2.00.0910151113340.9428@localhost.localdomain> <4AD711BC.2030409@garzik.org> <20091015160109.6d9353e8@lxorguk.ukuu.org.uk> <4AD73E40.1010501@garzik.org> <20091015163103.5e42fabe@lxorguk.ukuu.org.uk> <4AD74151.7020306@garzik.org>
 <20091015164906.5b2c03db@lxorguk.ukuu.org.uk> <4AD747EB.3040008@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Oct 2009, Jeff Garzik wrote:

> On 10/15/2009 11:49 AM, Alan Cox wrote:
> > There are cases where
> > 
> > 	case IOCWIBBLE:
> > 		return -EINVAL;
> > 
> > is correct but they are unusual - basically the case where the driver
> > author wants to "support" the ioctl but there is no argument that it can
> > be given which is correct.
> 
> This is the type of case I was referring to.

There is no real reason to believe that

int ioctl()
{
	return -EINVAL;
}

fall into above category.

Thanks,

	tglx
