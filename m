Return-Path: <linux-kernel-owner+w=401wt.eu-S1753056Ab0AJUlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0AJUlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 15:41:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752762Ab0AJUlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 15:41:22 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57487 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608Ab0AJUlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 15:41:21 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Constantin Baranov <const@mimas.ru>
Subject: Re: [BUG] Linux-2.6.32-git10 drm_i915 error
Date: Sun, 10 Jan 2010 21:41:32 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc3-rjw; KDE/4.3.3; x86_64; ; )
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Tarkan Erimer <tarkane@netone.com.tr>, linux-kernel@vger.kernel.org
References: <4B26349D.1080904@netone.com.tr> <201001101933.39683.rjw@sisk.pl> <20100110233703.9060e075.const@mimas.ru>
In-Reply-To: <20100110233703.9060e075.const@mimas.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001102141.32324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 January 2010, Constantin Baranov wrote:
> On Sun, 10 Jan 2010 19:33:39 +0100 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > On Sunday 10 January 2010, Maciej Rutecki wrote:
> > > 2009/12/14 Tarkan Erimer <tarkane@netone.com.tr>:
> > > > Frequently, I hit this bug on Linux-2.6.32-git10. It's always
> > > > re-producible for me on my i945 video device equipped HP machine. When
> > > > hit this bug, it crashes the X server and screen goes black. But,
> > > > possible to switch to console. Here is the error log, I had in dmesg:
> > > >
> > > > [ 2596.328132] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> > > > elapsed... GPU hung
> > > > [ 2596.328146] render error detected, EIR: 0x00000000
> > > > [ 2596.328167] [drm:i915_do_wait_request] *ERROR* i915_do_wait_request
> > > > returns -5 (awaiting 694588 at 694584)
> > > > [ 2596.439006] [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer
> > > > elapsed... GPU hung
> > > > [ 2596.439013] render error detected, EIR: 0x00000000
> > > >
> > > > Tarkan
> > > 
> > > I confirm this. A observed this on 2.6.33-rc3-git3 after resume from suspend:
> > > 
> > > Jan 10 08:51:31 gumis kernel: [  486.880045]
> > > [drm:i915_hangcheck_elapsed] *ERROR* Hangcheck timer elapsed... GPU
> > > hung
> > > Jan 10 08:51:31 gumis kernel: [  486.880063] render error detected,
> > > EIR: 0x00000000
> > > Jan 10 08:51:31 gumis kernel: [  486.880107]
> > > [drm:i915_do_wait_request] *ERROR* i915_do_wait_request returns -5 (
> > > awaiting 60107 at 60105)
> > > Jan 10 08:51:32 gumis kernel: [  487.276302] [drm:i915_gem_execbuffer]
> > > *ERROR* i915_gem_do_execbuffer returns -5
> > > Jan 10 08:51:32 gumis kernel: [  487.276799] [drm:i915_gem_execbuffer]
> > > *ERROR* i915_gem_do_execbuffer returns -5
> > > Jan 10 08:51:32 gumis kernel: [  487.277230] [drm:i915_gem_execbuffer]
> > > *ERROR* i915_gem_do_execbuffer returns -5
> > > Jan 10 08:51:32 gumis kernel: [  487.278308] [drm:i915_gem_execbuffer]
> > > *ERROR* i915_gem_do_execbuffer returns -5
> > > Jan 10 08:51:32 gumis kernel: [  487.278533] [drm:i915_gem_execbuffer]
> > > *ERROR* i915_gem_do_execbuffer returns -5
> > > 
> > > 2.6.33-rc2 works fine.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=15026 perhaps?
> 
> I have caught this bug in 2.6.31.9, 2.6.32.2, 2.6.33-rc3 and 2.6.33-rc3-git3
> on my Acer Aspire 1410T with Intel GM45 chipset. It is not needed to perform
> suspend and resume to reproduce the bug. The bug appears for me at startup
> of the Stellarium (trunk version).

The message may be the same, but the reason is different.

Rafael
