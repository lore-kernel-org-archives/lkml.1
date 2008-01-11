Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbYAWMtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbYAWMtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYAWMsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:48:54 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:4979 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751795AbYAWMsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:48:53 -0500
Date: Fri, 11 Jan 2008 18:16:59 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: make clflush a required feature on x86_64
Message-ID: <20080111181659.GB4016@ucw.cz>
References: <20080118045921.GB974@phobos.i.cabal.ca> <p734pdbbrwu.fsf@bingen.suse.de> <20080118060124.GC1726@phobos.i.cabal.ca> <479046BA.7090903@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479046BA.7090903@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-01-18 01:27:06, H. Peter Anvin wrote:
> Kyle McMartin wrote:
> >On Fri, Jan 18, 2008 at 06:53:53AM +0100, Andi Kleen 
> >wrote:
> >>One problem that we had in the past is that some 
> >>simulators
> >>only implement the absolutely minimum feature set and 
> >>you
> >>might have well broken one of these with this.
> >
> >Yeah, true. Please ignore the patch folks.
> >
> >cheers,	Kyle
> 
> Simulators can be fixed, even if it takes time; for 
> something like clflush this is easier since clflush can 
> be implemented as a simple noop for most of them.
> 
> I just verified that Bochs 2.3.0 lacks this CPUID bit 
> whereas the current version, 2.3.6, enables CLFLUSH iff 
> SSE2 is enabled.  Qemu 0.9.0 has CLFLUSH.  Andi, do you 
> happen to know of any specific simulators which are 
> problematic?  I would assume any recent version of 
> SimNow is up to date.

simics? It was very useful long time ago...
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
