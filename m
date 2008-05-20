Return-Path: <linux-kernel-owner+w=401wt.eu-S932814AbYETOl6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932814AbYETOl6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 10:41:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763847AbYETOlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 10:41:50 -0400
Received: from aun.it.uu.se ([130.238.12.36]:33086 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185AbYETOlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 10:41:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18482.58121.130009.555407@harpo.it.uu.se>
Date: Tue, 20 May 2008 16:41:13 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Dave Jones <davej@redhat.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       hpa@zytor.com
Subject: Re: [X86] Add a boot parameter to force-enable PAT
In-Reply-To: <20080520132306.GB4843@redhat.com>
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org>
	<86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com>
	<20080520132306.GB4843@redhat.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones writes:
 > On Mon, May 19, 2008 at 10:53:58PM -0700, Yinghai Lu wrote:
 >  
 >  > you don't need to set that bit again...
 >  > 
 >  > prevoious !test_cpu_cap(..) already get out.
 >  
 > 
 > * Add an enablepat boot parameter, useful for testing CPUs not yet
 >   added to the whitelist.
 > * Don't try to enable PAT if it was never enabled in the first place.
 > 
 > Signed-off-by: Dave Jones <davej@redhat.com>
 > 
 > diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
 > index 72c07a0..e179c22 100644
 > --- a/Documentation/kernel-parameters.txt
 > +++ b/Documentation/kernel-parameters.txt
 > @@ -236,6 +236,10 @@ and is between 256 and 4096 characters. It is defined in the file
 >  			try_unsupported: try to drive unsupported chipsets
 >  				(may crash computer or cause data corruption)
 >  
 > +	enablepat	[i386,x86-64]
 > +			Force the CPU's PAT feature to be used even if it
 > +			isn't in the kernels whitelist.

s/kernels/kernel's/
