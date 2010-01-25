Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536Ab0AYOXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab0AYOXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 09:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790Ab0AYOXe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 09:23:34 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:46525 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab0AYOXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 09:23:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=sqQ1CGY6Jk/Z62iMWZiX/2S3upFKBOw7YrsLj8ErS/oyA8pwpV+cCXhNTgLaOhYVKY
         DF5IlQPtZ195nKb9Y/l7UWH4vK0ksu33OpQhdKktgbv36W3/Vla+ICV91u0K/eRiWpoF
         EluvGaZVkFvfqKb+jsSd+pASSAdyCQrrp+l1E=
MIME-Version: 1.0
In-Reply-To: <20100122164248.GA2651@redhat.com>
References: <1264167553-6510-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100122164248.GA2651@redhat.com>
Date: Mon, 25 Jan 2010 23:15:33 +0900
X-Google-Sender-Auth: aa44257e972fb78e
Message-ID: <a6b9f31a1001250615y6e4501b3k17074bcc4ce26c7c@mail.gmail.com>
Subject: Re: [PATCH 00/12] perf lock: New subcommand "perf lock", for 
	analyzing lock statistics
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Jason Baron <jbaron@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason, thanks for your reply!

On Sat, Jan 23, 2010 at 01:42, Jason Baron <jbaron@redhat.com> wrote:
> On Fri, Jan 22, 2010 at 10:39:01PM +0900, Hitoshi Mitake wrote:
>> Adding new subcommand "perf lock" to perf.
>>
>
> looks like a really intresting patch! Does this patch mean that we can
> potentially remove CONFIG_LOCK_STAT, now that the functionality is
> available via 'perf'? Another desire for me has been to able to run
> lockstat on production box. This has not been possible before without
> incurring the performance penalty of lockdep. however, with 'perf' tools
> ability to be turned on an off, perhaps there is (or we can build) a
> mode for lockdep that is lower overhead for this usecase?
>

As Peter told, this patch series depends on lockdep.
But, checking dependency and tracing lock events are
essentially different things. So I think dividing these is possible.

But, perf depends on debugfs.
I don't know about production box well,
does your production box turns on debugfs?
It seems that debugfs is not a thing for production box...

And I'm interesting in in-kernel histogram of locks.
Is there requirement of it?
I have some ideas (not done yet, completely).

Thanks,
	Hitoshi
