Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZKQVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZKQVLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 16:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbZKQVLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 16:11:41 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:55260 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbZKQVLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 16:11:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YBR9RCzGIAsBTa6Yt7hwt3Kw9njz8JfTVcy/0bpEANImVQnAeuLaWOgdn2iM2x7T+C
         w9RlYIXqe5Q94Icx5SBBlu7W070AQbCsL5AzzJ0u4ENtT9hFa8DvLXE/ynClFDA7oYWA
         iyZLmKlmH1OcmFbp8Tufy/5WClyC3SWec8diI=
MIME-Version: 1.0
In-Reply-To: <4B030799.9020402@zytor.com>
References: <20091117191752.164451000@alcatraz.americas.sgi.com>
	 <20091117191757.651569000@alcatraz.americas.sgi.com>
	 <86802c440911171210x4780c08cg3b3260afd5d2bc5d@mail.gmail.com>
	 <4B030799.9020402@zytor.com>
Date: Tue, 17 Nov 2009 13:11:46 -0800
Message-ID: <86802c440911171311s1313abf5h4059422b1214ec75@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:29 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 11/17/2009 12:10 PM, Yinghai Lu wrote:
>>>
>>> The following lines have been removed:
>>>
>>>        CPU: Physical Processor ID:
>>>        CPU: Processor Core ID:
>>>        CPU %d/0x%x -> Node %d
>>
>> please don't.
>>
>
> Why not?
>
> Or, more formally: please state the rationale for keeping them.
>
at least one distribution: SLES 11 mess it up when BSP is from socket
1 instead of socket0

and above message does show kernel think BSP still from socket0, and
other cores in that package are from socket1.

YH
