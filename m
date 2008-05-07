Return-Path: <linux-kernel-owner+w=401wt.eu-S1757789AbYEGBXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757789AbYEGBXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:23:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbYEGBXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:23:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50249 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYEGBXL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:23:11 -0400
Message-ID: <48210431.6020008@cn.fujitsu.com>
Date: Wed, 07 May 2008 09:21:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix cpuset sched_relax_domain_level control file
References: <48210101.1070205@google.com>
In-Reply-To: <48210101.1070205@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> Fix cpuset sched_relax_domain_level control file
> 
> Due to a merge conflict, the sched_relax_domain_level control file was
> marked as being handled by cpuset_read/write_u64, but the code to handle it
> was actually in cpuset_common_file_read/write.
> 
> Since the value being written/read is in fact a signed integer, it
> should be treated as such; this patch adds cpuset_read/write_s64
> functions, and uses them to handle the sched_relax_domain_level file.
> 
> With this patch, the sched_relax_domain_level can be read and written,
> and the correct contents seen/updated.
> 
> Signed-off-by: Paul Menage <menage@google.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>
