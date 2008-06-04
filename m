Return-Path: <linux-kernel-owner+w=401wt.eu-S1760641AbYFDRWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760641AbYFDRWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbYFDRWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:22:33 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36562 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753442AbYFDRWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:22:32 -0400
Date: Wed, 4 Jun 2008 12:22:27 -0500
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: miaox@cn.fujitsu.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 2/2] cpusets: update tasks' cpus_allowed and
 mems_allowed after CPU/NODE offline/online
Message-Id: <20080604122227.a092e70e.pj@sgi.com>
In-Reply-To: <6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com>
References: <4845F864.8060102@cn.fujitsu.com>
	<6599ad830806040230l24bd1201y3cc0ea0273d835ad@mail.gmail.com>
	<6599ad830806040258h552e4623m5efae8202c5d026d@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M, quoting Miao Xie <miaox@cn.fujitsu.com>:
>>
>> Maybe we need to add a flag in the task_struct to mark which task can't be
>> unbound?

Do we need a new PF_* flag for this?  Perhaps one can test for this
by examining the currently available properties of tasks.  Would it
be sufficient to look for kernel threads (NULL mm_struct) whose
cpus_allowed is a strict subset of the online CPUs?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
