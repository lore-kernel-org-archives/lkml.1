Return-Path: <linux-kernel-owner+w=401wt.eu-S1755336AbYEWL7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755336AbYEWL7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYEWL64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:58:56 -0400
Received: from mail37.messagelabs.com ([216.82.244.163]:16615 "EHLO
	mail37.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYEWL6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:58:55 -0400
X-VirusChecked: Checked
X-Env-Sender: Uwe.Kleine-Koenig@digi.com
X-Msg-Ref: server-6.tower-37.messagelabs.com!1211543934!1454113!2
X-StarScan-Version: 5.5.12.14.2; banners=-,-,-
X-Originating-IP: [66.77.174.13]
Date: Fri, 23 May 2008 13:58:15 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
To: Tom Spink <tspink@gmail.com>
CC: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Jan Altenberg <jan.altenberg@linutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Message-ID: <20080523115815.GA6932@digi.com>
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local> <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com> <20080522200814.GD3226@local> <7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com> <20080523054115.GB28807@digi.com> <7b9198260805230448x56bf3bd1kade6083c141a75f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b9198260805230448x56bf3bd1kade6083c141a75f2@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 23 May 2008 11:58:16.0294 (UTC) FILETIME=[48ED9860:01C8BCCC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tom,

> > Tom Spink wrote:
> >> The added benefit is that the code becomes less complex, as you don't
> >> have to check buffer sizes and copy the integer from userspace.
> > AFAIK this is wrong.  You need to copy the integer from userspace in
> > uio_ioctl.  Actually it's a value coming from user space, so you need to
> > do it somewhere.
> 
> Not really in this case.  It's not a *pointer* to a value in
> userspace, so you don't need to copy anything.  If it was being used
> to point to a memory location holding a value, then yes, it would need
> to be copied across.  But in this case, it's just being used to pass
> across 1 or 0.
ah, OK, you're right.  Thanks for correcting my correction :-)

Uwe

-- 
Uwe Kleine-König, Software Engineer
Digi International GmbH Branch Breisach, Küferstrasse 8, 79206 Breisach, Germany
Tax: 315/5781/0242 / VAT: DE153662976 / Reg. Amtsgericht Dortmund HRB 13962
