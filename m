Return-Path: <linux-kernel-owner+w=401wt.eu-S936924AbYD1TgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936924AbYD1TgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 15:36:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933775AbYD1Tfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 15:35:44 -0400
Received: from hu-out-0506.google.com ([72.14.214.224]:20519 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935816AbYD1Tfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 15:35:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=hCDLl7vpj0iVgp6BPcZvPa8h1yiO49t2kXjxTheoOskGGDf5T7vpqlyG4CTJgfByl98/ENXRGHZR+eVwBMwQwxkiRV6/ACbmzs8/hqbK/RJM12lPshf7iQ3ubpce8J6a1dGmesjvHwF0jKv4vj9PkY3AKh8e/yjX9xRCuiLNzIA=
Date: Mon, 28 Apr 2008 22:35:35 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: ftrace and debugfs weird interaction
Message-ID: <20080428223535.4fe2aeca@daedalus.pq.iki.fi>
In-Reply-To: <20080428153956.GH18776@elte.hu>
References: <20080426185403.GA22522@Krystal>
	<20080428153956.GH18776@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hi,
> > 
> > When trying to figure out what was going on with the sched tracer
> > "tracing_enabled" file (sched-devel.git tree), I fell on this strange
> > behavior :
> > 
> > echo 1>tracing_enabled seems _not_ to send 1 to the tracing_ctrl_write

Wait a minute, are you literally running the command:
echo 1>tracing_enabled

If you are, you just echoed only a newline and directed stdout, stream 1,
to the file. No? :-)

Could you try with a space:
echo 1 > tracing_enabled

> > callback. However, sending garbage, e.g. echo s> tracing_enabled,
> > correctly sends the 's' character down the chain. echo 0>tracing_enabled
> > sometimes results in the callback not even being called.

Stream 0 is stdin, so... not sure what this would do. Probably nothing,
just like you experienced.


Thanks.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
