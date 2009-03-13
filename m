Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZCMImx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZCMImx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 04:42:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbZCMImn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 04:42:43 -0400
Received: from mx1.suse.de ([195.135.220.2]:50783 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbZCMImm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 04:42:42 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2] x86: mtrr: don't modify RdDram/WrDram bits of fixed MTRRs
Date: Fri, 13 Mar 2009 09:42:37 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.15-SLE11_BRANCH_20090211224354_e2f9ae3b-default; KDE/4.1.3; x86_64; ; )
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       "Greg Kroah-Hartman" <gregkh@novell.com>
References: <20090311150027.GK10490@alberich.amd.com> <20090312163937.GH20716@alberich.amd.com> <20090313015856.GA18760@elte.hu>
In-Reply-To: <20090313015856.GA18760@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903130942.38568.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009 02:58:56 Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Impact: bug fix + BIOS workaround
> 
> > Change to previous version:
> > I slightly modified the log message (e.g. addition of FW_WARN).
> > 
> > Please consider to apply this patch for .29.
> 
> i've applied it to tip:x86/mtrr, thanks Andreas.
> 
> I've add a -stable backport tag - so if it's problem-free it 
> should show up in .29.1.

What does -stable backport tag mean?
Is this something tip:x86 or Ingo Molnar specific?
I saw quite some "easy" fixes not being added/submitted to stable
in other subsystems and doing double work going through them,
pick them out and submit them to stable is an unnecessary waste
of time and some fixes will slip through.
Is there a general approach all maintainers should handle this?
If not, maybe you could suggest your way of handling this to others?

Thanks,

     Thomas
