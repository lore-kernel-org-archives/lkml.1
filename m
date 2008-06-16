Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYFPC6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYFPC6y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 22:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYFPC6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 22:58:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43586 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbYFPC6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 22:58:43 -0400
From: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
To: "'Masami Hiramatsu'" <mhiramat@redhat.com>
Cc: "'Frank Ch. Eigler'" <fche@redhat.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Hideo AOKI'" <haoki@redhat.com>, <mingo@elte.hu>,
       <linux-kernel@vger.kernel.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>
References: <20080602232135.GA20173@Krystal> <1212618449.19205.35.camel@lappy.programming.kicks-ass.net> <20080604232241.GA8488@Krystal> <1212653539.19205.47.camel@lappy.programming.kicks-ass.net> <20080612135319.GB22348@Krystal> <1213280823.31518.114.camel@twins> <20080612155332.GA16658@redhat.com> <48514BE3.3000506@redhat.com> <20080612164318.GB17814@redhat.com> <48515770.4020002@redhat.com> <20080612174834.GB22454@redhat.com> <48517A56.20603@redhat.com> <004101c8cd0c$aa093190$fe1b94b0$@css.fujitsu.com> <4852B628.8040906@redhat.com>
In-Reply-To: <4852B628.8040906@redhat.com>
Subject: RE: Kernel marker has no performance impact on ia64.
Date: Mon, 16 Jun 2008 11:58:52 +0900
Message-ID: <009301c8cf5c$e8c00ba0$ba4022e0$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcjNf/JRp+AvNVxJTP27YmLtrytHjgB2NciA
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Takashi Nishiie wrote:
>>   I think that I only have to add the item that shows the type of an 
>> accurate argument if the format of "Module.markers" is changed. 
>
Masami Hiramatsu wrote:
>I think those 'semantic' type information (which informs you what
>is this value and how this value should be recorded) should be
>defined by each tracer, because what information they want to
>extract from arguments are strongly depends on their use cases.
>
>Actually, that requires tracers to pay maintenance costs, but
>it's not so big if the "regular" marking point is enough stable.

  Certainly, because it only has to be able to acquire name of the 
point that wants to be traced, value that can be referred, the type, 
and those three items if interchangeability with an existing tool is 
not thought, it might not have to stick to a detailed thing. 

  By the way, 'pr_debug' and 'dev_debug' and 'DEBUGP', etc. might 
unite handling by replacing it with kernel markers. 

Thank you,

--
Takashi Nishiie



