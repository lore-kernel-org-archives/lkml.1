Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZJWS4I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZJWS4I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 14:56:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752575AbZJWS4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 14:56:08 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:36540 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbZJWS4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 14:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oPuwJTPM4PoEf8UVfvBlvRZ4nblaYctvfMd2OzKGLdnxzsJIWu5A1Fo3unLPyHQTtV
         1pNIpZGyfyv8k7q0/+8tRWq7tEraFOD182AccPvIl0vOQD+uwvXbwQ3NwcZCelOEfH2h
         p65cdgiCUn4vNGXwqQDnFgtQ8Aj3XkT/1zE80=
Date: Fri, 23 Oct 2009 20:56:08 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH] perf timechart: Use pr_debug to report unknown header
	types
Message-ID: <20091023185605.GA4913@nowhere>
References: <1256320245-8439-1-git-send-email-acme@redhat.com> <4AE1EE1B.2000500@linux.intel.com> <20091023183107.GA4132@ghostprotocols.net> <4AE1F807.9060907@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE1F807.9060907@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 23, 2009 at 11:37:59AM -0700, Arjan van de Ven wrote:
> Arnaldo Carvalho de Melo wrote:
>> Em Fri, Oct 23, 2009 at 10:55:39AM -0700, Arjan van de Ven escreveu:
>>> Arnaldo Carvalho de Melo wrote:
>>>> It was using eprintf that checked if verbose was !zero, when I converted
>>>> to pr_*() I made the mistake of changing it to pr_warning which caused
>>>> 'perf timechart' output to be way too verbose.
>>>>
>>> nack...
>>>
>>> if you EVER hit one of these you have a very very serious problem.
>>> hiding that is never the right thing to do. I should make this a fatal
>>> event instead.
>>
>> OK, so I actually fixed a bug as those messages weren't being noticed if
>> -v wasn't used! :-)
>>
>> Please take a look at latest tip to see all those messages.
>>
>> - Arnaldo
>
> I'm pretty sure latest -tip broke timechart; Frederic tends to have a habit of doing so occasionally :)
>


Yeah but I usually fix what I break. Because I need the things to be working
again if I want to happily continue breaking them :o)

/me wonders if he hasn't played too much legos when he was a child. That
may have provided him a strange vision of the world.

That said I've tested timechart few days ago and it worked very well. (That
was also the first time it worked for me).

So I guess it should be fine.

