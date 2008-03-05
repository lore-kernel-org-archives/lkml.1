Return-Path: <linux-kernel-owner+w=401wt.eu-S933472AbYCFOqE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472AbYCFOqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 09:46:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757999AbYCFOpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 09:45:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2000 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758244AbYCFOpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 09:45:54 -0500
Date: Wed, 5 Mar 2008 20:48:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 2/2] x86, fpu: lazy allocation of FPU area - v3
Message-ID: <20080305194801.GB4386@ucw.cz>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080303230336.042604000@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303230336.042604000@linux-os.sc.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-03-03 15:02:46, Suresh Siddha wrote:
> Only allocate the FPU area when the application actually uses FPU, i.e., in the
> first lazy FPU trap. This could save memory for non-fpu using apps.

How many such apps are on your system, and how much does this
'optimalization' cost?

ISTR glibc always using FPU...?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
