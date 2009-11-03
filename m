Return-Path: <linux-kernel-owner+w=401wt.eu-S1755580AbZKCI0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbZKCI0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 03:26:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926AbZKCI0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 03:26:09 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:31264 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZKCI0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 03:26:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AdVl4qfmMCeXU3apckktsUe04/lYcVCXTDrNi1w+zXpXrM3qcJ9chm5PwC3fxLHvhg
         mvmUBd5CwuN+76Y1ImyOLXQPLSL9DLokH2/z9fRrMQxTf2QUNRbIFzZVYQG8OWhJ/yLg
         0Q04+xe+dEONINuvCN5YN1ggI6vKXCqTcIQ0Q=
Date: Tue, 3 Nov 2009 09:26:13 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] ftrace: Fix unmatching locking in
	ftrace_regex_write()
Message-ID: <20091103082610.GB4815@nowhere>
References: <4AEF7F8A.3080300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF7F8A.3080300@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:55:38AM +0800, Li Zefan wrote:
>  # echo 'do_open : foo' > set_ftrace_filter
>  (still holding ftrace_regex_lock when returning to user space!)
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

