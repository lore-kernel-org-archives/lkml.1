Return-Path: <linux-kernel-owner+w=401wt.eu-S1753980AbYFXHPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980AbYFXHPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 03:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYFXHPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 03:15:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48178 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbYFXHPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 03:15:30 -0400
From: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
To: "'Masami Hiramatsu'" <mhiramat@redhat.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>
Cc: "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
References: <485BE2C6.1080901@redhat.com> <20080620174529.GB10943@Krystal> <1213992446.3223.195.camel@lappy.programming.kicks-ass.net> <20080622171135.GA19432@Krystal> <20080622175928.GA5022@martell.zuzino.mipt.ru> <20080622182705.GA23301@Krystal> <20080624002010.GA4777@martell.zuzino.mipt.ru> <486071AF.3080709@redhat.com>
In-Reply-To: <486071AF.3080709@redhat.com>
Subject: RE: [RFC] Tracepoint proposal
Date: Tue, 24 Jun 2008 16:15:35 +0900
Message-ID: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcjVr3udlatoxZXBQNiaDBqIOeu+xwAGXRGg
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Hiramatsu wrote:
>One reason why we need markers or other in-the-middle-of-function 
>trace point is that some events happen inside functions, not it's 
>interface.

  Each kernel sub-system seems to have its own way of dealing with 
debugging statements. Some of these methods include 'dprintk', 
'pr_debug', 'dev_debug', 'DEBUGP'. I think that these functions are
the tracepoints that has been availably mounted without setting up 
the tool set of the outside. I think whether mounting that unites 
these functions can be done if kernel marker and tracepoint are used.


  By the way, isn't there problem on security?
  What kprobe, jprobe, and kernel marker, etc. offer looks like what 
the framework of Linux Security Module had offered before. Gotten 
kprobe, jprobe, and kernel marker, etc. should not be exported to the 
userland for security because it becomes the hotbed of rootkits. Users
such as kprobe, jprobe, and kernel marker should not be Loadable Kernel
Module. I think that there are some solutions in LTTng about this 
security problem. However, will the environment to be able to operate
SystemTap be really secure?
　At least, kernel commandline option to invalidate all of kprobe, 
jprobe, and kernel marker, etc. because of the batch might be 
necessary.

Thank you,

--
Takashi Nishiie



