Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498AbZLRA6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbZLRA6M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 19:58:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbZLRA6L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 19:58:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50436 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752192AbZLRA6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 19:58:10 -0500
Message-ID: <4B2AD38D.3070605@cn.fujitsu.com>
Date: Fri, 18 Dec 2009 08:57:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: lkml <linux-kernel@vger.kernel.org>, eduard.munteanu@linux360.ro,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: kmemtrace.txt question: kernel parameter(s)?
References: <20091217141342.9ae2072b.randy.dunlap@oracle.com>
In-Reply-To: <20091217141342.9ae2072b.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Hi,
> 
> Documentation/trace/kmemtrace.txt says:
> 
> Q: 'cat /sys/kernel/debug/kmemtrace/total_overruns' is non-zero, how do I fix
> this? Should I worry?
> A: If it's non-zero, this affects kmemtrace's accuracy, depending on how
> large the number is. You can fix it by supplying a higher
> 'kmemtrace.subbufs=N' kernel parameter.
> 
> 
> Where is this kernel parameter implemented and where is it documented?
> or should this Answer just be fixed?
> 

The whole documentation is out-dated. The original kmemtrace was based on
relay, and then it moved to ftrace, without updating the documentation.
