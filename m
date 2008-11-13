Return-Path: <linux-kernel-owner+w=401wt.eu-S1753703AbYKMJjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703AbYKMJjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 04:39:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751817AbYKMJjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 04:39:01 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:58325 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYKMJi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 04:38:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=pmwTB5jJX/VfcjRCBQIrwkQjSGOrgCSDfQhkbaweMcewChHRuP2c99J71pncfEuzYU
         PyVV8r0XavZib0VYCIwXS5Mido0asaIlz36UaMBCbeuPoLCKpibfu4jo1pJ/KqJ12HYl
         89pSPnJ5eohvKuvFAPdUWiXq4b2O5KPLWFFDk=
Message-ID: <c62985530811130138v69b260dcy59adfba24afee0ca@mail.gmail.com>
Date: Thu, 13 Nov 2008 10:38:58 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 2/2] tracing/function-return-tracer: Call prepare_ftrace_return by registers
Cc: "Steven Rostedt" <rostedt@goodmis.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081113085949.GG25479@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491B4F63.3090909@gmail.com> <20081112221623.GB6125@elte.hu>
	 <c62985530811121422w6d33de3cp506bdf1aa96efd81@mail.gmail.com>
	 <alpine.DEB.1.10.0811121824380.21116@gandalf.stny.rr.com>
	 <c62985530811121535t13a60c93y9e4c22e365ca1b34@mail.gmail.com>
	 <alpine.DEB.1.10.0811121911340.30248@gandalf.stny.rr.com>
	 <20081113085949.GG25479@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/11/13 Ingo Molnar <mingo@elte.hu>:
> hm, function-exit is a quite bad name i think that tells nothing to
> the user. I like "function-cost tracer" because that tells the user
> what it's all about in the end.
>
> Or perhaps we could name it the "callgraph" tracer? (as opposed to the
> simpler function tracer which traces function entries) Note that we
> could use the output to build function call coverage graphs.


But you can build a call graph with the function tracer, that what
does the script draw_trace.py
in a bit loosely way for example.
IMHO, function cost measurement or call graphs are particular uses
that can be made of this engine.
You can also use it to trace function return values for example.

The general sense of this is more about return hooking.
But....
Perhaps defining it as a "return" tracer is not easy to understand at
a first sight and could bring developpers
on misinterpretation (sorry does this word exist?).

So perhaps naming it by thinking on the purpose it could be use at
most would be better that its "general" or "potential"
purpose. I don't know...

> It definitely must convey the idea that this is a more capable (and
> also more expensive) form of function tracing.
>
>        Ingo
>


If we convey/consider it on a sight where it is capable on several
things, so a more generic name should be chosen.
