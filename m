Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443AbZCXIat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbZCXIat (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 04:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZCXIai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 04:30:38 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:59888 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbZCXIah (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 04:30:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eQrYtJI3UWic/aRgHEq6RMSs6W84J20w8ubZ6D+OSJTij11+2KEfxvqGT0WldtE3o6
         2euMzbUrPthnsQ/FU1cqnQah0GlzbKtcLluzlLmW9psHvY7SesKOzazWqOZ9hB5upjWK
         tH3xzAv+89V79ZZgZ0U1FpKK1adKksl3GDmk0=
Date: Tue, 24 Mar 2009 10:31:11 +0200
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Ingo Molnar <mingo@elte.hu>
Cc: rostedt@goodmis.org, compudj@krystal.dyndns.org, fweisbec@gmail.com,
       penberg@cs.helsinki.fi, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] kmemtrace: update usage of
	ring_buffer_lock_reserve()
Message-ID: <20090324083111.GB5383@localhost>
References: <cover.1237813499.git.eduard.munteanu@linux360.ro> <c56426665804da261115c2883818c5fea6b217b6.1237813499.git.eduard.munteanu@linux360.ro> <20090323145556.GA21267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323145556.GA21267@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 23, 2009 at 03:55:56PM +0100, Ingo Molnar wrote:
> 
> * Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro> wrote:
> 
> > The ring buffer API has changed a bit and kmemtrace wasn't 
> > compiling anymore. This fixes the issue and allows kmemtrace to 
> > build.
> > 
> > Signed-off-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> 
> hm, kmemtrace was building and working fine in -tip:
> 
>  [root@aldebaran tracing]# head trace
>  # tracer: kmemtrace
>  #
>  type_id 0 call_site 18446744071565600429 ptr 18446612139794190624
>  type_id 0 call_site 18446744071565600392 ptr 18446612146227278976
>  type_id 1 call_site 18446744071564535786 ptr 18446612146228083456
>  type_id 0 call_site 18446744071565600392 ptr 18446612146240588256
>  type_id 1 call_site 18446744071564535786 ptr 18446612146240893824
> 
> the build error that is fixed by you here was introduced by your 
> earlier 4/7 patch in this series:
> 
>    kmemtrace: use tracepoints
> 
> So i've backmerged patch 7/7 into patch 4/7. Agreed?
> 
> 	Ingo

My bad, thanks. Sounds fine to me.


	Eduard

