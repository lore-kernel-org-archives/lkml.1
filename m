Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbZLGHOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbZLGHOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 02:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757044AbZLGHOD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 02:14:03 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:47596 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbZLGHOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 02:14:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=WYHiYtLb8XaMGdVvljJxgj2M202vrxpLNhaEOdwxqu0CZDTeQwSRi/fz5ytLCiTZhk
         3N9R42z+5z8w1TzngTWag2iTKxjpi16WgWawnK4kdsO0P/zmGzZoHJFY4CdR3glGzvQU
         rO66k4zh3ZTQBNN2yuHsJ38+DMvBF0RyG1eu0=
Subject: Re: [PATCH 0/2] perf trace/scripting: A couple bugfixes
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
       acme@ghostprotocols.net
In-Reply-To: <20091207070556.GB10868@elte.hu>
References: <1260163919-6679-1-git-send-email-tzanussi@gmail.com>
	 <20091207070556.GB10868@elte.hu>
Content-Type: text/plain
Date: Mon, 07 Dec 2009 01:14:06 -0600
Message-Id: <1260170046.6632.11.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 08:05 +0100, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > One fixes a compile error when libperl isn't installed, the other
> > fixes an annoying message about scripting being unsupported even when
> > the perf trace cmd isn't trying to use scripting.
> > 
> > Tom Zanussi (2):
> >   perf trace/scripting: Fix compile err when libperl not installed
> >   perf trace/scripting: Don't display 'scripting unsupported' msg
> >     unnecessarily
> > 
> >  tools/perf/util/trace-event-perl.c |   67 +++++++++++++++++++++++++++++------
> >  tools/perf/util/trace-event-perl.h |    4 ++
> >  2 files changed, 59 insertions(+), 12 deletions(-)
> 
> Applied, thanks a lot Tom!
> 
> ( Note, i already applied patch #1 out of your previous email - this 
>   version has the same content, right? )
> 

Yeah, it's the same.

Thanks,

Tom

> 	Ingo

