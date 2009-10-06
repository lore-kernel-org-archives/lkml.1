Return-Path: <linux-kernel-owner+w=401wt.eu-S1756799AbZJFJlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799AbZJFJlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 05:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756727AbZJFJlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 05:41:15 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:62938 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756714AbZJFJlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 05:41:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yCLjmqLq8xz8F1s1G5OQs1KKz1hmMkdHJQFIrdPJeTfYGiBdMpnKDkyEu/KvG06T5X
         UiHRfP5bpeSGmgdQe5Mam5hDIe3+gP6hkQERtsziTNgUzDwmVL6B9aOC4uazYomOkUPW
         iE1S7svDrCA0S5pHBS7wCKxAKSKAcMRiCMmKY=
MIME-Version: 1.0
In-Reply-To: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
References: <1254809398-8078-1-git-send-email-tzanussi@gmail.com>
Date: Tue, 6 Oct 2009 11:40:37 +0200
Message-ID: <c62985530910060240y6755a8acgf235db0845202540@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/9] perf trace: support for general-purpose 
	scripting
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, rostedt@goodmis.org,
       lizf@cn.fujitsu.com, hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/6 Tom Zanussi <tzanussi@gmail.com>:
> Hi,
>
> This patchset defines a generic interface for processing the binary
> output of 'perf trace' and making it directly available to
> user-defined scripts written in general-purpose scripting languages
> such as Perl or Python.  It also builds a general-purpose Perl
> scripting trace processor on top of the new interface and provides a
> few example scripts that exercise the basic functionality.
>
> The main motivation behind it is to provide a more efficient and
> powerful alternative to the popular method of parsing the ascii trace
> output in order to extract useful information from it.  To avoid the
> overhead and complexity of all that, this patchset provides a
> direct-to-script-interpreter pathway for doing the same thing, but in
> a more regularized fashion, one that takes advantage of all the event
> meta-info provided by the tracing infrustructure, such as the
> event/field info contained in the 'format files' designed for that
> purpose.


That's really a great thing! I was also hesitating to implement a
python interface to perf in
order to quickly plug post processing tools. But your patchset does
that in a much more
generic way that I imagined: we can support other languages, we have
well defined
callbacks to process the events...

Really nice, I hope we can give it a try in -tip soon.
