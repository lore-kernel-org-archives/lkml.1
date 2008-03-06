Return-Path: <linux-kernel-owner+w=401wt.eu-S932651AbYCFVVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651AbYCFVVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 16:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762288AbYCFVUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 16:20:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56987 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761662AbYCFVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 16:20:46 -0500
Date: Thu, 6 Mar 2008 22:21:16 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080306212116.GC1747@elf.ucw.cz>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com> <20080305194801.GB4386@ucw.cz> <20080306192653.GI28006@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306192653.GI28006@linux-os.sc.intel.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-03-06 11:26:53, Suresh Siddha wrote:
> On Wed, Mar 05, 2008 at 08:48:01PM +0100, Pavel Machek wrote:
> > On Mon 2008-03-03 15:02:46, Suresh Siddha wrote:
> > > Only allocate the FPU area when the application actually uses FPU, i.e., in the
> > > first lazy FPU trap. This could save memory for non-fpu using apps.
> > 
> > How many such apps are on your system, and how much does this
> > 'optimalization' cost?
> 
> On a normal kernel boot, where there are 200 or so tasks running, only 20
> or so apps seem to be using FPU.

Aha, now I see it is useful ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
