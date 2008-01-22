Return-Path: <linux-kernel-owner+w=401wt.eu-S1761936AbYAVKGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761936AbYAVKGZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 05:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756475AbYAVKGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 05:06:17 -0500
Received: from hellhawk.shadowen.org ([80.68.90.175]:2782 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879AbYAVKGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 05:06:16 -0500
Date: Tue, 22 Jan 2008 10:06:24 +0000
From: Andy Whitcroft <apw@shadowen.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: remove casts
Message-ID: <20080122100609.GA12154@shadowen.org>
References: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr> <20080118104553.GB8785@elte.hu> <Pine.LNX.4.64.0801191455180.27831@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0801191455180.27831@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2008 at 02:56:05PM +0100, Jan Engelhardt wrote:
> 
> On Jan 18 2008 11:45, Ingo Molnar wrote:
> >* Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> >> This is against x86/mm.
> >
> >hm, it has checkpatch failures -
> 
> All false positives.

The spacing thing is definately a matter for argument elsewhere.  I
cirtainly have no real oppinion on the matter.  As has been said
elsewhere the coding style is not meant to be as everyone likes it, more
a minimally offensive common position generating consistancy out of
caos.

Checkpatch is _meant_ to push you towards the recommendations in
CodingStyle, that is the definative resource; common sense should prevail
over it.  <standard message>checkpatch is a style guide only, think
about its output and be prepared to justify any non-complience.</standard
message>.

The second one is a clear falsie which I believe I have fixed for the
next release, rather over zelous "possible type" detection has fired here.

ERROR: "foo * bar" should be "foo *bar"
#123: FILE: arch/x86/kernel/microcode.c:248:
+                         EXT_SIGNATURE_SIZE * i;

Cheers.

-apw
