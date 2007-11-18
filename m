Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbXKRNGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbXKRNGd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 08:06:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbXKRNG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 08:06:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:48068 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbXKRNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 08:06:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=MYeArv0U/5kVDeTvvHSaiNKRn/uaT13j5uKMkzXj+63ZaF3usH/xSjiifnu6J0+raQD95yTLEERUUk6Or0ZZHK1AbfV4arPpXGlAcGAewDKkVGGBg0LQEdPHi/hNX+8k3WqN2I2mCGPb4HmiKbsns00yuST/03t7E+i8XW16Zc4=
Message-ID: <474038C9.3040002@gmail.com>
Date: Sun, 18 Nov 2007 14:06:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711171649100.7748-100000@netrider.rowland.org> <4740332A.80002@gmail.com>
In-Reply-To: <4740332A.80002@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2007 01:42 PM, Jiri Slaby wrote:
> See shot of prints here:
> http://www.fi.muni.cz/~xslaby/sklad/susp_hang1.png

BTW output from that tree minus the patch:
_cpu_down: s
_cpu_down: t
CPU 1 is now offline
SMP alternatives: switching to UP code
_cpu_down: u
notifier_call_chain: c FFFFFFFF80232370 1
notifier_call_chain: c FFFFFFFF8026EF10 1
notifier_call_chain: c FFFFFFFF8024B8F0 1
notifier_call_chain: c FFFFFFFF802419E0 1
notifier_call_chain: c FFFFFFFF80255B50 1
notifier_call_chain: c FFFFFFFF80250C40 1
notifier_call_chain: c FFFFFFFF8028E8F0 1
notifier_call_chain: c FFFFFFFF802B59C0 1
notifier_call_chain: c FFFFFFFF80323460 1
notifier_call_chain: c FFFFFFFF80270990 0
notifier_call_chain: c FFFFFFFF8023D5D0 1
notifier_call_chain: c FFFFFFFF80266090 1
notifier_call_chain: c FFFFFFFF802320A0 1
notifier_call_chain: c FFFFFFFF80249DA0 1
notifier_call_chain: c FFFFFFFF80318440 1
notifier_call_chain: c FFFFFFFF8047BE80 1
notifier_call_chain: c FFFFFFFF80212F40 0
notifier_call_chain: c FFFFFFFF80216350 1
notifier_call_chain: c FFFFFFFF80217220 1
notifier_call_chain: c FFFFFFFF80218120 1
_cpu_down: v
_cpu_down: w
_cpu_down: x
_cpu_down: y
_cpu_down: z
disable_nonboot_cpus: 3 0

regards,
-- 
Jiri Slaby (jirislaby@gmail.com)
Faculty of Informatics, Masaryk University
