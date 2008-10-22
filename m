Return-Path: <linux-kernel-owner+w=401wt.eu-S1757783AbYJVTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783AbYJVTWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755254AbYJVTWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 15:22:05 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42507 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755142AbYJVTWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 15:22:03 -0400
Date: Wed, 22 Oct 2008 15:19:48 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: make oops_begin and oops_end equal
Message-ID: <20081022191948.GB20423@hmsreliant.think-freely.org>
References: <20081017210013.GD23591@hmsreliant.think-freely.org> <20081020121339.GE10594@elte.hu> <20081020134211.GA15574@hmsreliant.think-freely.org> <20081020150731.GA25999@mailshack.com> <20081020150834.GA26018@mailshack.com> <20081021144505.GA25750@hmsreliant.think-freely.org> <1224670721.25843.1280616145@webmail.messagingengine.com> <20081022104513.GA18951@hmsreliant.think-freely.org> <20081022120222.GE8095@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022120222.GE8095@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2008 at 02:02:22PM +0200, Ingo Molnar wrote:
> 
> * Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > > Thanks for the review. I've sent a redone patch series just a moment 
> > > ago, based on your comments. There was also another problem with 
> > > these two patches: oops_end(flags, regs, signr) had special 
> > > behaviour for regs=NULL that I did not consider before. The series 
> > > has grown due to this issue...
> 
> [...]
> > Copy that.  Thanks for the quick turn-around.
> 
> applied to tip/x86/dumpstack, thanks guys!
> 
> Could you please also create arch/x86/kernel/dumpstack.c and move all 
> the now-unified bits there - before they get out of sync again?
> 
I can do this in the next day or so, unless you have an urge to Alexander
Neil

> 	Ingo
> 

-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
