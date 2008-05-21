Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbYEUHvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbYEUHvj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 03:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757432AbYEUHv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 03:51:29 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:29263 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755590AbYEUHv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 03:51:28 -0400
Date: Wed, 21 May 2008 16:49:50 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, "Hans J. Koch" <hjk@linutronix.de>,
       linux-kernel@vger.kernel.org, gregkh@suse.de, linux-sh@vger.kernel.org
Subject: Re: [PATCH 00/03][RFC] Reusable UIO Platform Driver
Message-ID: <20080521074950.GA27310@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Uwe Kleine-K?nig <Uwe.Kleine-Koenig@digi.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	"Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
	gregkh@suse.de, linux-sh@vger.kernel.org
References: <20080520105132.1474.73941.sendpatchset@rx1.opensource.se> <20080520210713.GE3220@local> <aec7e5c30805202031x62b3b463lfde0b9e7eb32d35@mail.gmail.com> <20080521064938.GA11580@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080521064938.GA11580@digi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 08:49:38AM +0200, Uwe Kleine-K?nig wrote:
> Magnus Damm wrote:
> >         Extending uio_pdrv driver with a chunk of physically
> > contiguous memory isn't a big deal though.
> I wonder how you use that memory.  Isn't it just some kind of shared
> memory?  If so, why not use normal shared memory?  Do you really need
> that?
> 
Physically contiguous memory is a real requirement, especially for DMA.
I'm not sure what's confusing about that?
