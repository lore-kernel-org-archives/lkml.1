Return-Path: <linux-kernel-owner+w=401wt.eu-S1756045AbYETEO6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045AbYETEO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 00:14:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbYETEOu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 00:14:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbYETEOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 00:14:49 -0400
Date: Tue, 20 May 2008 00:14:38 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: Re: [X86] Remove unnecessary code in 64bit CPU identification.
Message-ID: <20080520041438.GA22594@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	hpa@zytor.com
References: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 12:09:35AM -0400, Dave Jones wrote:
 > There were no 64bit Transmeta CPUs made (and it'd be something of
 > a surprise if they started any time soon).   To the best of my knowledge,
 > no CPU vendor cloned the 80860000 cpuid space claimed by Transmeta.
 > By removing this code, we can also eliminate calling cpuid 0x80000007 twice.

argh, after reading this a dozen times, I send it, and then notice a typo.
That should be ' eliminate calling cpuid 0x80000000 twice'

	Dave

-- 
http://www.codemonkey.org.uk
