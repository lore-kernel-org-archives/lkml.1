Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYJWJWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYJWJWo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 05:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYJWJWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 05:22:36 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:57227 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751428AbYJWJWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 05:22:35 -0400
Message-Id: <1224753754.1503.1280816335@webmail.messagingengine.com>
X-Sasl-Enc: 9MkFevIQE0b1nHmTajS2ZCzTXfCVN26CEbiSXBKLMusl 1224753754
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Neil Horman" <nhorman@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>
Cc: "Alexander van Heukelum" <heukelum@mailshack.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       vgoyal@redhat.com, hbabu@us.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, mingo@redhat.com,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20081017210013.GD23591@hmsreliant.think-freely.org>
 <20081020121339.GE10594@elte.hu>
 <20081020134211.GA15574@hmsreliant.think-freely.org>
 <20081020150731.GA25999@mailshack.com>
 <20081020150834.GA26018@mailshack.com>
 <20081021144505.GA25750@hmsreliant.think-freely.org>
 <1224670721.25843.1280616145@webmail.messagingengine.com>
 <20081022104513.GA18951@hmsreliant.think-freely.org>
 <20081022120222.GE8095@elte.hu>
 <20081022191948.GB20423@hmsreliant.think-freely.org>
Subject: Re: [PATCH] x86: make oops_begin and oops_end equal
In-Reply-To: <20081022191948.GB20423@hmsreliant.think-freely.org>
Date: Thu, 23 Oct 2008 11:22:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 15:19:48 -0400, "Neil Horman"
<nhorman@tuxdriver.com> said:
> On Wed, Oct 22, 2008 at 02:02:22PM +0200, Ingo Molnar wrote:
> > 
> > * Neil Horman <nhorman@tuxdriver.com> wrote:
> > 
> > > > Thanks for the review. I've sent a redone patch series just a moment 
> > > > ago, based on your comments. There was also another problem with 
> > > > these two patches: oops_end(flags, regs, signr) had special 
> > > > behaviour for regs=NULL that I did not consider before. The series 
> > > > has grown due to this issue...
> > 
> > [...]
> > > Copy that.  Thanks for the quick turn-around.
> > 
> > applied to tip/x86/dumpstack, thanks guys!
> > 
> > Could you please also create arch/x86/kernel/dumpstack.c and move all 
> > the now-unified bits there - before they get out of sync again?
> > 
> I can do this in the next day or so, unless you have an urge to Alexander

Hi Neil,

Many thanks for the review of the patches, and please go ahead
and finish the unification!

Greetings,
    Alexander

> Neil
> 
> > 	Ingo
> > 
> 
> -- 
> /****************************************************
>  * Neil Horman <nhorman@tuxdriver.com>
>  * Software Engineer, Red Hat
>  ****************************************************/
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - A fast, anti-spam email service.

