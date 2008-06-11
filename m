Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbYFKE40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbYFKE40 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 00:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbYFKE4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 00:56:15 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:45830
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYFKE4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 00:56:14 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Tim Bird <tim.bird@am.sony.com>
Subject: Re: mainlining min-configs...
Date: Tue, 10 Jun 2008 22:32:44 -0500
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Adrian Bunk <adrian.bunk@movial.fi>, linux-tiny <Linux-tiny@selenic.com>,
       linux-embedded <linux-embedded@vger.kernel.org>,
       linux kernel <linux-kernel@vger.kernel.org>
References: <48447615.5050806@am.sony.com> <200806062329.54019.rob@landley.net> <484DDAD9.2000306@am.sony.com>
In-Reply-To: <484DDAD9.2000306@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806102232.45571.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 June 2008 20:37:29 Tim Bird wrote:
> Rob Landley wrote:
> > On Friday 06 June 2008 18:47:47 Tim Bird wrote:
> >> At a minimum, it would be nice to have a few nice examples
> >> of really, really small configs for things like qemus for different
> >> architectures (just to give embedded developers who are working
> >> on size a starting point).
> >
> > That's more or less what I'm trying to do with my Firmware Linux project:
> > creating cross compilers and minimal native build environments for every
> > qemu target.
>
> Any chance of getting your minimal configs from Firmware Linux mainlined?

There's _slightly_ more to it than that if you want to actually get a working 
environment.  (For example, I'm feeding ppc an extra patch and a boot rom, 
both from Milton Miller.  The config is useless without those.  I can walk 
you through the status and reasoning of each platform if you'd like...)

I have no objection to people taking the configs I worked out for my purposes 
and using them for any purpose if they want to do so, but my idea 
of "working" involves having a hard drive and a network connection (so I can 
run builds under the emulator using distcc to call out to the cross 
compiler).  It's the minimal functionality _I_ need.  I'm just offering it as 
a starting point, because you specifically mentioned configs for qemu.

If you're looking to compare and contrast configurations, possibly a more 
_useful_ thing would be to convert all the kernel's existing *_defconfig 
files to *_miniconfig files so you could see what they all _are_.

Lemme take a stab at that, actually...

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
