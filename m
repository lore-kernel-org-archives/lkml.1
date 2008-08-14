Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbYHNOOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbYHNOOk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbYHNOOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:14:31 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:63957 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750757AbYHNOOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:14:30 -0400
Date: Thu, 14 Aug 2008 18:14:28 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Laurent Pinchart <laurentp@cse-semaphore.com>
Cc: linuxppc-dev@ozlabs.org, Greg Kroah-Hartman <greg@kroah.com>,
       linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Yang <leoli@freescale.com>, linux-kernel@vger.kernel.org,
       Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 1/3] gpiolib: make gpio_to_chip() public
Message-ID: <20080814141428.GA32296@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080808161717.GA19095@polina.dev.rtsoft.ru> <20080808161813.GA31258@polina.dev.rtsoft.ru> <200808141604.22287.laurentp@cse-semaphore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Disposition: inline
In-Reply-To: <200808141604.22287.laurentp@cse-semaphore.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 04:04:18PM +0200, Laurent Pinchart wrote:
> On Friday 08 August 2008, Anton Vorontsov wrote:
> > We'll need this function to write platform-specific hooks to deal
> > with pin's dedicated functions. Quite obviously this will work only
> > for the platforms with 1-to-1 GPIO to PIN mapping.
> > 
> > This is stopgap solution till we think out and implement a proper
> > api (pinlib?).
> 
> How do you support reverting the GPIO mode to non-dedicated ?

As we always do with the GPIO API: gpio_direction_*() calls.

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
