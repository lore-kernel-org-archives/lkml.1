Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbYGJOyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbYGJOyf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYGJOy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:54:28 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60331 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752750AbYGJOy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:54:27 -0400
Date: Thu, 10 Jul 2008 09:54:27 -0500
From: Russ Anderson <rja@sgi.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       Jack Steiner <steiner@sgi.com>
Subject: Re: [patch] x86 BIOS interface for RTC on SGI UV
Message-ID: <20080710145426.GA2392@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20080709202719.GB22744@sgi.com> <4875697A.2010605@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4875697A.2010605@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 09:44:26PM -0400, H. Peter Anvin wrote:
> Russ Anderson wrote:
> >[patch] x86 BIOS interface for RTC on SGI UV
> >
> >Real-time code needs to know the number of cycles per second
> >on SGI UV.  The information is provided via a run time BIOS
> >call.  This patch provides the linux side of that interface.
> >This is the first of several run time BIOS calls to be defined
> >in uv/bios.h and bios_uv.c.
> >
> >Note that BIOS_CALL() is just a stub for now.  The bios 
> >side is being worked on.
> >
> 
> Do you have a proposed specification that could be reviewed before it is 
> cast in stone?

I would like to follow the ia64 SAL spec (http://download.intel.com/design/itanium/specupdt/245359.pdf).
There is no corresponding Intel spec for x86_64.

For examples of what I would like, see the ia64 files:
include/asm-ia64/sal.h, include/asm-ia64/sn/sn_sal.h, and
arch/ia64/kernel/sal.c.



-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
