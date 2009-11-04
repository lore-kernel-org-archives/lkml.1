Return-Path: <linux-kernel-owner+w=401wt.eu-S1753602AbZKDBof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbZKDBof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 20:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbZKDBod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 20:44:33 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:39529 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbZKDBob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 20:44:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oNNFiAQAMh3+tPXuTvvImmVmMZZ2wjQdvtSRAZmnBIwXePbNgIrsp5g87jQv4rLJai
         UAycBU8zN+jEEs9cRJzBRFeKWNp5MHhOwWRXNWpso93LaQ3mODvKHTd+Kj1KnB3J7qVg
         9Xbpbhn316d94uO+Cgc7TiHf5IEGrrDvDkujQ=
Date: Wed, 4 Nov 2009 02:44:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ftrace: Return EINVAL when writing invalid val to
	set_ftrace_filter
Message-ID: <20091104014435.GB5092@nowhere>
References: <4AEF7F8A.3080300@cn.fujitsu.com> <4AEF7FBC.2050802@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF7FBC.2050802@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:56:28AM +0800, Li Zefan wrote:
> Currently it doesn't warn user on invald value:
> 
>  # echo nonexist_symbol > set_ftrace_filter
> 
> Better make it return failure.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---


Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

But shouldn't we have the same kind of check from
ftrace_match_module_records() if we haven't matched
anything with the regex?

