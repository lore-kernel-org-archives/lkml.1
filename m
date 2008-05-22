Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbYEVQku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbYEVQku (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 12:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbYEVQkc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 12:40:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755160AbYEVQkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 12:40:31 -0400
Date: Thu, 22 May 2008 10:04:20 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Remove unnecessary code in 64bit CPU identification.
Message-ID: <20080522140420.GA20613@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200805200409.m4K49ZuE024343@gelk.kernelslacker.org> <4832E461.2070503@zytor.com> <20080520151655.GA542@redhat.com> <4833112F.7020402@zytor.com> <20080520191812.GB31805@redhat.com> <4834B670.80606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4834B670.80606@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 04:55:28PM -0700, H. Peter Anvin wrote:
 > Dave Jones wrote:
 > > 
 > > Moving along the same direction..  Moving the vendor specific bits out of setup_64.c
 > > into cpu/ would go a long way towards killing of setup64.c.  I took a first pass at doing this
 > > in the diff below. So far I only looked at the AMD specific bits, and haven't done
 > > a complete conversion to cpu_dev style initialisation as done on 32bit, but that
 > > can easily be performed later after moving all the code out into its respective places.
 > > (downside: a bunch of externs in the interim).
 > > 
 > > comments on this before I go any further?
 > > 
 > 
 > Hi Dave,
 > 
 > I was going to pull this into -tip, but I need a Signed-off-by: line in 
 > order to do so.  Could you resend this so we can add it to -tip?

Yeah, I was going to rediff against tip and resend them, but I went
into the office instead yesterday, where nothing productive ever happens :-)

I'll get to it today.

	Dave

-- 
http://www.codemonkey.org.uk
