Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZIRCX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZIRCX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 22:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753494AbZIRCX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 22:23:27 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:49978 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319AbZIRCX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 22:23:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=T0XxwS8PQQmmuLtLFMyauHCeA5hl0SOZV9/VrVhbRinGBuZrMn/qDxoxLCVw++3XJ6
         ExsWqbjgleCgrQxjaMKQjEbsKaMgf4O8jUHAoEmD+y/4c4aNn8jjn8ZRqEtA7fY3i017
         DRfPBc97JO5Mvq3JWBCF5PKxJ7osNYJ7sWzyY=
Date: Fri, 18 Sep 2009 04:23:27 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jason Baron <jbaron@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 2/2] tracing: Allocate the ftrace event profile buffer
	dynamically
Message-ID: <20090918022325.GA5310@nowhere>
References: <1253237613-5589-1-git-send-email-fweisbec@gmail.com> <1253237613-5589-3-git-send-email-fweisbec@gmail.com> <1253240103.20020.253.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253240103.20020.253.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 10:15:03PM -0400, Steven Rostedt wrote:
> 
> Is this allocating a buffer for every event? Why not just have one? All
> events can share the same buffer. It's only a temp buffer, and can only
> be used by one event at a time per cpu.
> 
> -- Steve
> 


Oh you're right. That was so obvious though...

The v2 is coming soon.

Thanks.

