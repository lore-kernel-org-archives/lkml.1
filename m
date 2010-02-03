Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab0BCQMq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 11:12:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39474 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab0BCQMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 11:12:34 -0500
X-Authority-Analysis: v=1.0 c=1 a=iO19At-cfDAA:10 a=7U3hwN5JcxgA:10 a=hBteppYTM2-xv2vuYj4A:9 a=DHBPnAna-u3Zq6GMDAjESUHY2HwA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 4/4] kconfig: Add LSMOD=file to override the lsmod for
 localmodconfig
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Anibal Monsalve Salazar <anibal@debian.org>
In-Reply-To: <20100203160708.GA9035@sepie.suse.cz>
References: <20100203154605.461025238@goodmis.org>
	 <20100203154906.499020585@goodmis.org>
	 <20100203160708.GA9035@sepie.suse.cz>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 11:12:33 -0500
Message-ID: <1265213553.24386.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 17:07 +0100, Michal Marek wrote:
> On Wed, Feb 03, 2010 at 10:46:09AM -0500, Steven Rostedt wrote:
> > +# if no path is given, then use src directory to find file
> > +ifdef LSMOD
> > +LSMOD_F = $(shell if [ `basename $(LSMOD)` == $(LSMOD) ]; then \
> > +		echo $(objtree)/$(LSMOD);			\
> > +	else							\
> > +		echo $(LSMOD);					\
> > +	fi)
> > +endif
> 
> You can do this within make like:
> 
> ifdef LSMOD
> LSMOD_F := $(LSMOD)
> ifeq ($(findstring /,$(LSMOD)),)
>   LSMOD_F := $(objtree)/$(LSMOD)
> endif
> endif

You can send me a patch and I'll apply it on top.

Thanks,

-- Steve


