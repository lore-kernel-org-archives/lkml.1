Return-Path: <linux-kernel-owner+w=401wt.eu-S932684AbXBTT1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbXBTT1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 14:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932961AbXBTT1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 14:27:37 -0500
Received: from mx1.redhat.com ([66.187.233.31]:55083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932684AbXBTT1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 14:27:36 -0500
Date: Tue, 20 Feb 2007 14:25:00 -0500
From: Dave Jones <davej@redhat.com>
To: Alexey Dobriyan <adobriyan@openvz.org>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] {rd,wr}msr_on_cpu SMP=n optimization
Message-ID: <20070220192500.GA5142@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Alexey Dobriyan <adobriyan@openvz.org>,
	Adrian Bunk <bunk@stusta.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org> <20070220000713.GP13958@stusta.de> <20070220001434.GG16332@redhat.com> <20070220135044.GA11164@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220135044.GA11164@localhost.sw.ru>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 04:50:44PM +0300, Alexey Dobriyan wrote:
 > On Mon, Feb 19, 2007 at 07:14:34PM -0500, Dave Jones wrote:
 > > On Tue, Feb 20, 2007 at 01:07:13AM +0100, Adrian Bunk wrote:
 > >  > On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
 > >  > >...
 > >  > > Changes since 2.6.20-rc6-mm3:
 > >  > >...
 > >  > > +rdmsr_on_cpu-wrmsr_on_cpu.patch
 > >  > >...
 > >  > >  x86 updates
 > >  > >...
 > >  >
 > >  > Let's save a few bytes in the CONFIG_SMP=n case.
 > >  >
 > >  > Signed-off-by: Adrian Bunk <bunk@stusta.de>
 > >  >
 > >  > ---
 > >  >
 > >  > BTW: currently -ENOUSERS
 > >
 > > There was a follow-on patch that converted p4-clockmod to use it for one.
 > 
 > And patch for powernow-k8 in preparations.

Cool. Can you resend me the p4-clockmod diff, I seem to have lost it.
I've just merged up the *msr_on_cpu diff (and will apply Adrians cleanup too).

thanks,

		Dave

-- 
http://www.codemonkey.org.uk
