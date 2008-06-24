Return-Path: <linux-kernel-owner+w=401wt.eu-S1756269AbYFXRDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbYFXRDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 13:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYFXRDa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 13:03:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42344 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbYFXRD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 13:03:29 -0400
Message-ID: <48612879.5090809@redhat.com>
Date: Tue, 24 Jun 2008 13:01:45 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Mathieu Desnoyers'" <mathieu.desnoyers@polymtl.ca>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC] Tracepoint proposal
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KOSAKI Motohiro wrote:
>> Tracepoint
>>  - stored in a section
>>  - dynamic activation
>>  - no message
>>  - export kernel structure
>>  - arguments depending on points
>>  - high frequently called
>>  - no module support (kernel use only)
> 
> Why Shouldn't kernel module use tracepoint?
> technical problem? or any plicy exist?

Good question, I think we don't want to export so much
kernel internal structures. Since tracepoint tend to export
raw kernel structure to user module, I thought it might be
better not to export its interface to modules.

However, I thought that again, and knew what Peter worried was
about marker which exports marker list to user space.
So, the issue is exporting internal structures to user space,
not to modules. Thus, I think it can support modules also.

Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

