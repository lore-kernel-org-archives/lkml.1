Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbYAPWgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbYAPWgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 17:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYAPWgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 17:36:07 -0500
Received: from wr-out-0506.google.com ([64.233.184.235]:41806 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbYAPWgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 17:36:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qquY+jgKF+H/HeOTU78F06y4VpfYAEnrTKaUAPPYxVq60KuBS6yU+LIlLUxPiOp41/68eGRIw5ZvAJSMKcZHhpsrCY1r1nVCXdeDtIhcDa3qYRIl5VoNx3JXLuXSd1TvcrIAnnRFiXwUPX4oZtyW6/FCOR0viYMNOY0IhyCJijs=
Message-ID: <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
Date: Wed, 16 Jan 2008 14:36:02 -0800
From: "john stultz" <johnstul@us.ibm.com>
To: "Mathieu Desnoyers" <mathieu.desnoyers@polymtl.ca>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Gregory Haskins" <ghaskins@novell.com>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Tim Bird" <tim.bird@am.sony.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "Steven Rostedt" <srostedt@redhat.com>,
       "Paul Mackerras" <paulus@samba.org>,
       "Daniel Walker" <dwalker@mvista.com>, johnstul@us.ibm.com
In-Reply-To: <20080116145604.GB31329@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.777564395@goodmis.org>
	 <20080115214636.GD17439@Krystal>
	 <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
	 <20080115220824.GB22242@Krystal>
	 <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
	 <20080116031730.GA2164@Krystal>
	 <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
	 <20080116145604.GB31329@Krystal>
X-Google-Sender-Auth: bbc72e6c00e85baf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 16, 2008 6:56 AM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> If you really want an seqlock free algorithm (I _do_ want this for
> tracing!) :) maybe going in the RCU direction could help (I refer to my
> RCU-based 32-to-64 bits lockless timestamp counter extension, which
> could be turned into the clocksource updater).

Yea. After our earlier discussion and talking w/ Steven, I'm taking a
swing at this now.  The lock-free method still doesn't apply to the
update_wall_time function, but does work fine for the monotonic cycle
uses.  I'll send a patch for review as soon as I get things building.

thanks
-john
