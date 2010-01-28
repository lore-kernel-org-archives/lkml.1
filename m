Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085Ab0A1URv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab0A1URv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 15:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535Ab0A1URu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 15:17:50 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:39097 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab0A1URt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 15:17:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NP5P/7XfGv3IZUeCGFY2VAdblf6BJLc4+05Yi2aJqOg320n4JvXsNM01ztFzvkpzvM
         Zd4iynqfz2NIwD+H69SsS2zImkpHa5DBYHwMtKeYhIjkX+wEdlv81YkGQRK45NJDPqPe
         GNrKt49Vd4ym+hxO2F9cuWYXSMDH+32RZMDI8=
Date: Thu, 28 Jan 2010 21:17:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/4] x86,hw_breakpoint,kgdb: kgdb to use
	hw_breakpointAPI
Message-ID: <20100128201745.GE18683@nowhere>
References: <1264480000-6997-1-git-send-email-jason.wessel@windriver.com> <1264480000-6997-2-git-send-email-jason.wessel@windriver.com> <20100128171050.GA18683@nowhere> <4B61CD14.7000901@windriver.com> <4B61EC62.6030103@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B61EC62.6030103@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 28, 2010 at 01:58:26PM -0600, Jason Wessel wrote:
> New version which loses the call back registration, because if we
> register as a different breakpoint type, perf won't reject it.



I don't understand what you mean here.



>  I didn't
> see that loop hole in the API the first time around.
> 
> Also the dr7 fixup in hw_breakpoint.c is not needed.
> 
> The trickery for entering twice into the __kgdb_notify is gone too.
> 
> All the regression tests are still passing.



Ok. Well, let's go for it, as it's a regression that
needs to be fixed anyway.

But we'll need to sanitize various things after that :)

