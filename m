Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZLKMKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZLKMKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 07:10:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbZLKMKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 07:10:32 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:63091 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754738AbZLKMKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 07:10:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=p6ZG8G3NpVaBgOM1IEjsyXGZ9lw5dsVjft/i8dxBw54db75yWODrUwkQ+tNw0ck33r
         gcsb5KH6jF07lkdODqUh5LG8tXU+jTlUJ4ZFzfq+uFMaHZHp7xc0qmHkBfmijVyaQ/7v
         zxVQyIcHAP74LkyhoPezLCfOCzPQ9a9DWgBh4=
Date: Fri, 11 Dec 2009 13:10:33 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Wenji Huang <wenji.huang@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] ftrace: Fix MATCH_END_ONLY filter matching
Message-ID: <20091211121030.GF5244@nowhere>
References: <4B2217D0.5000308@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B2217D0.5000308@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 11, 2009 at 05:58:40PM +0800, Li Zefan wrote:
> For '*foo' pattern, we should allow any string ending with
> 'foo', but ftrace filter incorrectly disallows strings
> like bar_foo_foo:
> 
>   # echo '*io' > set_ftrace_filter
>   # cat set_ftrace_filter | grep 'req_bio_endio'
>   # cat available_filter_functions | grep 'req_bio_endio'
>   req_bio_endio
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


I have pending fixes in queue, I'm taking this one too.

Thanks!

