Return-Path: <linux-kernel-owner+w=401wt.eu-S1753002AbZIIB17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbZIIB17 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 21:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752980AbZIIB17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 21:27:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56147 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752744AbZIIB15 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 21:27:57 -0400
Message-ID: <4AA70451.6050307@cn.fujitsu.com>
Date: Wed, 09 Sep 2009 09:26:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Eric Biederman <ebiederm@xmission.com>
Subject: Re: [PATCH 2/2] tracing/events: Add kexec tracepoints
References: <4AA70198.9070500@cn.fujitsu.com>  <4AA701B3.704@cn.fujitsu.com> <1252459241.14793.40.camel@desktop>
In-Reply-To: <1252459241.14793.40.camel@desktop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
> On Wed, 2009-09-09 at 09:15 +0800, Li Zefan wrote:
>> +       TP_STRUCT__entry(
>> +               __string(       msg,    msg     )
>> +       ),
> 
> Why the funny spacing here?
> 

To make the code better-looking.

This is the coding-style we use for the code in
include/trace/events/*.

Run scripts/checkpatch.pl to include/trace/events/foo.h,
you'll get a bunch of ERRORs. We ignore them, because the
script is not applicable here.

