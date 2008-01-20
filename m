Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbYATFAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbYATFAC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 00:00:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYATE7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 23:59:52 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:54062
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752335AbYATE7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 23:59:51 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-tiny@selenic.com
Subject: Re: [PATCH] x86: =?utf-8?q?fix=09unconditional=09arch/x86/kernel/pcspeaker=2Ec=3Fcompiling?=
Date: Sat, 19 Jan 2008 22:59:46 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Matt Mackall <mpm@selenic.com>,
       Michael Opdenacker <michael-lists@free-electrons.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
References: <200801171643.49301.michael-lists@free-electrons.com> <4790D3E3.4060409@free-electrons.com> <1200676219.3835.8.camel@cinder.waste.org>
In-Reply-To: <1200676219.3835.8.camel@cinder.waste.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801192259.47063.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2008 11:10:19 Matt Mackall wrote:
> >     * Disable support for readahead, page writeback, pdflush and swap
> >       when we have no storage at all (typically booting from an
> >       initramfs). This corresponds to 69 KB of source code!
>
> That'd be nice, yes. It would probably make sense to be able to disable
> just readahead support when we're working with only solid-state devices.

Very nice.  From a UI standpoint, shouldn't disabling the block layer take at 
least some of that out?  (Or disabling the block layer and all network 
filesystems.  /me tries to remember whether jffs2 depends on the block layer.  
Now that qemu can fake an mtd, I really need to start playing with that...)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
