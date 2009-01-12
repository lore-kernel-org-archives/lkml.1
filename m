Return-Path: <linux-kernel-owner+w=401wt.eu-S1756264AbZALSvs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264AbZALSvs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 13:51:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbZALSv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 13:51:28 -0500
Received: from adelie.canonical.com ([91.189.90.139]:44406 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZALSv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 13:51:27 -0500
Date: Mon, 12 Jan 2009 18:51:14 +0000
From: Andy Whitcroft <apw@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: checkpatch warning of struct indentation
Message-ID: <20090112185114.GB13925@shadowen.org>
References: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0901121253350.22796@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 12:57:23PM -0500, Steven Rostedt wrote:
> 
> Hi,
> 
> I'm now seeing the following warnings from checkpatch:
> 
> #325: FILE: kernel/trace/trace_stat.c:21:
> +	void 			*stat;
> 
> ERROR: "foo 	*bar" should be "foo *bar"
> #334: FILE: kernel/trace/trace_stat.c:27:
> +	struct tracer_stat 	*ts;
> 
> ERROR: "foo		*bar" should be "foo	*bar"
> #337: FILE: kernel/trace/trace_stat.c:30:
> +	struct dentry		*file;

Yes those are bogus.  They should be fixed in the latest push to akpm.
You can check that with this version:

  http://www.kernel.org/pub/linux/kernel/people/apw/checkpatch/checkpatch.pl-testing

-apw
