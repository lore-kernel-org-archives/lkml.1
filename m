Return-Path: <linux-kernel-owner+w=401wt.eu-S1761623AbYD3Hy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761623AbYD3Hy5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755261AbYD3Hyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 03:54:50 -0400
Received: from mail.free-electrons.com ([88.191.46.45]:3489 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbYD3Hyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 03:54:49 -0400
X-Greylist: delayed 1350 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Apr 2008 03:54:49 EDT
Message-ID: <4818205B.7050202@free-electrons.com>
Date: Wed, 30 Apr 2008 09:31:39 +0200
From: Michael Opdenacker <michael-lists@free-electrons.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Stas Sergeev <stsp@aknet.ru>
CC: Sam Ravnborg <sam@ravnborg.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Takashi Iwai <tiwai@suse.de>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Vojtech Pavlik <vojtech@suse.cz>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       linux-tiny <Linux-tiny@selenic.com>
Subject: Re: [patch] pcspkr: fix dependancies
References: <4813476A.7000705@aknet.ru> <200804261918.14711.dtor-oss@comcast.net> <4813BD39.1080105@aknet.ru> <20080427042331.GB29127@anvil.corenet.prv> <481626B6.5040207@aknet.ru> <20080428155811.ZZRA012@mailhub.coreip.homeip.net> <20080428201225.GB18135@uranus.ravnborg.org> <48177D70.5010803@aknet.ru>
In-Reply-To: <48177D70.5010803@aknet.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2008 09:56 PM, Stas Sergeev wrote:
> Reading the thread, it actually seems
> like Michael wanted to submit the patch
> much like the aforementioned one of
> mine:
> http://kerneltrap.org/mailarchive/linux-kernel/2008/1/18/580583
> but haven't done so in time, and as the
> result, the wrong one stuck in.
> But this is never too late to correct, I
> hope.
>
> So I see 2 options: either revert the
> patch completely, or revert the dependancies
> like Michael suggested initially (if I
> understand his suggestion right).
> Both patches are here, in this thread.
> Thoughts?
>
>   
Stas, Dmitry,

I agree with you... on a regular system, all the platform devices should
be enumerated, even if we don't use their drivers. It's only for use in
embedded devices (CONFIG_EMBEDDED) that we could omit this enumeration
to reduce kernel size.

Would you post a patch doing this?

Thank you,

:-)

Michael.

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

