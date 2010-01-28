Return-Path: <linux-kernel-owner+w=401wt.eu-S1753367Ab0A1Vyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab0A1Vyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 16:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473Ab0A1Vyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 16:54:35 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:48684 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab0A1Vyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:54:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ONUfUDOjz8sTTWVQf2L8zKUdKFJTeyj6LIP4i2O+fjMMS99CaaY0tJ+cgooeRnW6rQ
         MV4WxR17r5GapRijhu1iaIQ6fi6amsvycfKtc1rpaONoybzIPrUAPCrcx/KbEVatKfdq
         Vm9qiahUD8EuvZKIVXHdkVOtDLdeQbQ4ntnN4=
Date: Thu, 28 Jan 2010 22:54:32 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] x86,hw_breakpoint,kgdb: kgdb to usehw_breakpointAPI
Message-ID: <20100128215430.GG18683@nowhere>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-2-git-send-email-jason.wessel@windriver.com> <20100128171050.GA18683@nowhere> <4B61CD14.7000901@windriver.com> <4B61EC62.6030103@windriver.com> <20100128201745.GE18683@nowhere> <4B61F231.4030108@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61F231.4030108@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 02:23:13PM -0600, Jason Wessel wrote:
> Frederic Weisbecker wrote:
> > On Thu, Jan 28, 2010 at 01:58:26PM -0600, Jason Wessel wrote:
> >   
> >> New version which loses the call back registration, because if we
> >> register as a different breakpoint type, perf won't reject it.
> >>     
> >
> >
> >
> > I don't understand what you mean here.
> >
> >
> >
> >   
> 
> This was the change:
> 
> -       attr.bp_type = HW_BREAKPOINT_X;
> +       attr.bp_type = HW_BREAKPOINT_W;
> 
> The perf API had extra constraint checks when you did not have a call
> back function and the type was HW_BREAKPOINT_X.   Using the
> HW_BREAKPOINT_W type avoids the extra checks that would not allow me to
> register without providing a call back.  


Oh, where have you seen this?



> > Ok. Well, let's go for it, as it's a regression that
> > needs to be fixed anyway.
> >
> > But we'll need to sanitize various things after that :)
> >   
> 
> 
> Agreed. 
> 
> Can I take that to mean you have acked this version of the patch?
> 
> Thanks,
> Jason.


Yep, please add my ack.

Thanks!

