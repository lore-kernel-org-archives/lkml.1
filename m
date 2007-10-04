Return-Path: <linux-kernel-owner+w=401wt.eu-S1762344AbXJDXeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762344AbXJDXeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 19:34:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbXJDXeC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 19:34:02 -0400
Received: from waste.org ([66.93.16.53]:50630 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755796AbXJDXeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 19:34:00 -0400
Date: Thu, 4 Oct 2007 12:13:11 -0500
From: Matt Mackall <mpm@selenic.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Andrew Morton <akpm@osdl.org>, Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 2/3] Prepare pid_nr() etc functions to work with not-NULL pids
Message-ID: <20071004171311.GZ19691@waste.org>
References: <4703A44F.9020402@openvz.org> <4703A53B.9090804@openvz.org> <20071003164258.GS19691@waste.org> <4704AA39.5030208@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4704AA39.5030208@openvz.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2007 at 12:54:17PM +0400, Pavel Emelyanov wrote:
> Matt Mackall wrote:
> > On Wed, Oct 03, 2007 at 06:20:43PM +0400, Pavel Emelyanov wrote:
> >> Just make the __pid_nr() etc functions that expect the argument
> >> to always be not NULL.
> >>
> >> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
> > 
> >>  static inline pid_t pid_nr(struct pid *pid)
> >>  {
> >>  	pid_t nr = 0;
> >>  	if (pid)
> >> -		nr = pid->numbers[0].nr;
> >> +		nr = __pid_nr(pid);
> >>  	return nr;
> >>  }
> > 
> > Is there a patch that removes these inlines? Otherwise this looks good
> > to me.
> 
> Not yet. Some of are uninlined already, but others are not. I'd like 
> to make some testing before uninline them.

I was asking about the whole function, actually, not the keyword. Is
this function not equivalent to __pid_nr now?

-- 
Mathematics is the supreme nostalgia of our time.
